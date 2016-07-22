//
//  Artist+CoreDataProperties.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/22/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artist {

    @NSManaged var fullname: String?
    @NSManaged var url: String?
    @NSManaged var albums: NSSet?

}
