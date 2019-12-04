//
//  Entry+CoreDataProperties.swift
//  P10 Diary
//
//  Created by Tom Bastable on 03/12/2019.
//  Copyright © 2019 Tom Bastable. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        return request
    }

    @NSManaged public var entryImages: Data?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var mainBody: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var title: String?
    @NSManaged public var dateCreated: Date?

}
