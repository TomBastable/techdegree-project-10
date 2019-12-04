//
//  EntryViewController.swift
//  P10 Diary
//
//  Created by Tom Bastable on 03/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class EntryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var entryTitle: UILabel!
    @IBOutlet weak var entrySubtitle: UILabel!
    @IBOutlet weak var entryCreatedDate: UILabel!
    @IBOutlet weak var entryBody: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var imageArray:[UIImage] = []
    var entry: Entry?
    var context: NSManagedObjectContext!
    
    //MARK: - VDL

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load up images, map and text.
        setupImages()
        setupMap()
        setupText()
        
        //setup vanity settings for the UI
        self.overrideUserInterfaceStyle = .dark
        self.entryBody.sizeToFit()
        self.collectionView.showsHorizontalScrollIndicator = false
    }
    
    //MARK:- Setup Map
    
    func setupMap(){
        
        //check for valid entry
        if let entry = entry{
        //setup coordinates for display -init empty
            var latitude: Double = 0.0
            var longitude:Double = 0.0
            //safely convert to Double
            if let lat = entry.latitude, let doubleLat = Double(lat), let long = entry.longitude, let doubleLong = Double(long) {

                    latitude = doubleLat
                    longitude = doubleLong
            
            }
            //set center & region
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //set the maps region
            self.mapView.setRegion(region, animated: true)
        
            
            
        }else{
            
            //Display Error
            self.displayAlertWith(error: DiaryError.errorDisplayingEntry)
            
        }
        
    }
    
    //MARK: - Setup Text
    
    func setupText(){
        //check for valid entry
        if let entry = entry{
            //set labels text to entry data
            self.entryTitle.text = entry.title
            self.entrySubtitle.text = entry.subTitle
            self.entryCreatedDate.text = "\(String(describing: entry.dateCreated))"
            self.entryBody.text = entry.mainBody
            
        }else{
            //if no valid entry, display error
            self.displayAlertWith(error: DiaryError.errorDisplayingEntry)
            
        }
        
    }
    
    //MARK: - Setup Images
    
    func setupImages() {
        
        //check to make sure there's an array to fetch (Convert via extension at the same time)
        if let retrievedImgArray = entry?.entryImages?.imageArray() {
           //check for empty array
            if !retrievedImgArray.isEmpty {
            //set the imagearray to the retrieved array
            imageArray = retrievedImgArray
            print("\(imageArray.count) images")
            //reload the collection view to display images
            DispatchQueue.main.async {
             self.collectionView.reloadData()
            }
            
            }else {
                
                //if empty array, display error
                self.displayAlertWith(error: DiaryError.errorDisplayingImages)
                
            }
        }else{
            
            //if error fetching array, display error
            self.displayAlertWith(error: DiaryError.errorDisplayingImages)
            
        }
        
    }
    
    //MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //init cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! EntryCollectionViewCell
        
        //set entry image to cell image view
        let image = imageArray[indexPath.row]
        cell.entryImage.image = image
        
        return cell
    }
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editEntry" {
            
            let entryVC = segue.destination as! EntryCreationViewController
            
            entryVC.entry = entry
            entryVC.managedObjectContext = context
            
        }
        
    }

}
