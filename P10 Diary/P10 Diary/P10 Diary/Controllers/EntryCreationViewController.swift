//
//  EntryCreationViewController.swift
//  P10 Diary
//
//  Created by Tom Bastable on 03/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import CoreData
import Photos

class EntryCreationViewController: UIViewController, TatsiPickerViewControllerDelegate, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var entryTitle: UITextField!
    @IBOutlet weak var entrySubtitle: UITextField!
    @IBOutlet weak var entryContents: UITextField!
    @IBOutlet weak var addPhotosButton: UIButton!
    var managedObjectContext:NSManagedObjectContext!
    var photoChoices: Data?
    let locationManager = CLLocationManager()
    var longitude: String = "0.0"
    var latitude: String = "0.0"
    var entry: Entry?
    
    //MARK: - VDL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if entry is valid, it means the user is editing an entry.
        if let entry = entry {
            
            //display entry properties in the UI for ease of editing.
            self.entryTitle.text = entry.title
            self.entrySubtitle.text = entry.subTitle
            self.entryContents.text = entry.mainBody
            self.photoChoices = entry.entryImages
        }
        
        //Request user permission for location (When in use)
        self.locationManager.requestWhenInUseAuthorization()
        
        //check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            
            //set delegate, accuracy and start updating location.
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: -  Custom Image Picker (third party) - allows picking of multiple images
    
    @IBAction func addPhotos(_ sender: Any) {
        
        //Set tatsi config
        var config = TatsiConfig.default
        config.showCameraOption = true
        config.supportedMediaTypes = [.image]
        config.firstView = .userLibrary
        config.maxNumberOfSelections = 15
        
        //set delegate and present
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
        
    }
    
    //MARK: - Save Entry
    
    @IBAction func saveEntry(_ sender: Any) {
        
        //guard let the entry data
        guard let title = entryTitle.text, let subtitle = entrySubtitle.text, let contents = entryContents.text else{
            //will only fall through with invalid chars
            self.displayAlertWith(error: DiaryError.invalidText)
            return
        }
        //check for zero count strings
        if title.count == 0 || subtitle.count == 0 || contents.count == 0 || photoChoices == nil {
            //display need for all fields to be filled, return function
            self.displayAlertWith(error: DiaryError.insufficientEntryData)
            return
        }
        
        //if item is present, update the edited item.
        if let entry = entry {
            
            //set item properties
            entry.title = title
            entry.subTitle = subtitle
            entry.mainBody = contents
            entry.entryImages = photoChoices!
            entry.longitude = longitude
            entry.latitude = latitude
            entry.dateCreated = Date()
            //save and pop to root.
            managedObjectContext.saveChanges()
            navigationController?.popToRootViewController(animated: true)
            
        }else{
        //start new entry
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        //set new entries properties
        entry.title = title
        entry.subTitle = subtitle
        entry.mainBody = contents
        entry.entryImages = photoChoices!
        entry.longitude = longitude
        entry.latitude = latitude
        entry.dateCreated = Date()
        //save and pop to root
        managedObjectContext.saveChanges()
        navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    //MARK: - Picker Delegate - deal with picked results.
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        pickerViewController.dismiss(animated: true, completion: nil)
        //empty image array
        var array: [UIImage] = []
        //cycle through returned assets, using the extension to PHAsset
        for asset in assets{
            //append image
            array.append(asset.image)
            
        }
        
        //assign coredatarepresentation to photo choices (Extension to Array).
        let coreDataObject = array.coreDataRepresentation()
        photoChoices = coreDataObject
        
    }
    
    //MARK: - Location Manager Did Update Locations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //set longitude and latitude
        longitude = "\(locValue.longitude)"
        latitude = "\(locValue.latitude)"
        
    }

}

//MARK: - Extensions

//Extension to PHAsset to easily convert self to UIImage

extension PHAsset {

    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            thumbnail = image!
        })
        
        return thumbnail
    }
}

//Extension to Array to easily convert an array of UIImage to a saveable data representation

typealias ImageArray = [UIImage]
typealias ImageArrayRepresentation = Data

extension Array where Element: UIImage {
    // Given an array of UIImages return a Data representation of the array suitable for storing in core data as binary data that allows external storage
    func coreDataRepresentation() -> ImageArrayRepresentation? {
        let CDataArray = NSMutableArray()

        for img in self {
            guard let imageRepresentation = img.pngData() else {
                print("Unable to represent image as PNG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)
        }

        return try! NSKeyedArchiver.archivedData(withRootObject: CDataArray, requiringSecureCoding: false)
    }
}

//extension to typealias of Data to easily unarchive the array of images

extension ImageArrayRepresentation {
    // Given a Data representation of an array of UIImages return the array
    func imageArray() -> ImageArray? {
        if let mySavedData = try! NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: self) {
            // TODO: Use regular map and return nil if something can't be turned into a UIImage
            let imgArray = mySavedData.compactMap({
                return UIImage(data: $0 as! Data)
            })
            return imgArray
        }
        else {
            print("Unable to convert data to ImageArray")
            return nil
        }
    }
}
