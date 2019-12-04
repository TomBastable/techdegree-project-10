//
//  P10_DiaryTests.swift
//  P10 DiaryTests
//
//  Created by Tom Bastable on 02/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//

import XCTest
import CoreData

@testable import P10_Diary

class P10_DiaryTests: XCTestCase {
    
    
    var managedObjectContext = CoreDataStack().managedObjectContext

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        managedObjectContext = CoreDataStack().managedObjectContext
    }
    
    func testEntryCreation(){
        
        //start new entry
        let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as! Entry
        //set new entries properties
        
        let arrayImage: [UIImage] = [UIImage(named:"diary")!]
        
        entry.title = "one"
        entry.subTitle = "one two"
        entry.mainBody = "one two three"
        entry.entryImages = arrayImage.coreDataRepresentation()
        entry.longitude = "1.0"
        entry.latitude = "1.0"
        entry.dateCreated = Date()
        
        managedObjectContext.saveChanges()
        
        do {
            
            let request = NSFetchRequest<Entry>(entityName: "Entry")
            request.returnsObjectsAsFaults = false
            let result = try managedObjectContext.fetch(request)
            
            XCTAssertTrue(result.contains(entry))
            
        } catch let error {
            
            XCTAssert(false, "Failed to save diary entry \(error)")
            
        }
        
    }
    
    func testEntryEdit(){
        
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as? Entry else {
            return
        }
        
        let arrayImage: [UIImage] = [UIImage(named:"diary")!]
        
        entry.title = "two"
        entry.subTitle = "two three"
        entry.mainBody = "two three four"
        entry.entryImages = arrayImage.coreDataRepresentation()
        entry.longitude = "2.0"
        entry.latitude = "2.0"
        entry.dateCreated = Date()
        
        managedObjectContext.saveChanges()
        
        entry.mainBody = "Hello der"
        
        managedObjectContext.saveChanges()
        
        do {
             
         let request = NSFetchRequest<Entry>(entityName: "Entry")
         request.returnsObjectsAsFaults = false
         let result = try managedObjectContext.fetch(request)
         
         XCTAssertTrue(result.contains{ $0.mainBody == "Hello der"})
         
        } catch let error {
            
            XCTAssert(false, "Failed to save entry \(error)")
            
        }
        
        
    }
    
    func testEntryDeletion(){
        
        guard let entry = NSEntityDescription.insertNewObject(forEntityName: "Entry", into: managedObjectContext) as? Entry else {
            return
        }
        
        let arrayImage: [UIImage] = [UIImage(named:"diary")!]
        entry.title = "three"
        entry.subTitle = "three four"
        entry.mainBody = "three four five"
        entry.entryImages = arrayImage.coreDataRepresentation()
        entry.longitude = "3.0"
        entry.latitude = "3.0"
        entry.dateCreated = Date()
        
        managedObjectContext.saveChanges()
        
        managedObjectContext.delete(entry)
        
        managedObjectContext.saveChanges()
        
        do {
            
            let request = NSFetchRequest<Entry>(entityName: "Entry")
            request.returnsObjectsAsFaults = false
            let result = try managedObjectContext.fetch(request)
            
            XCTAssertFalse(result.contains(entry))
            
        } catch let error {
            XCTAssert(false, "Failed to save diary entry \(error)")
        }
        
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
