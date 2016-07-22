//
//  CoreDataStack.swift
//  MVVM_FindSong
//
//  Created by Adrian TABIRTA on 7/22/16.
//  Copyright © 2016 Adrian TABIRTA. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack  {
    
    let mainContext: NSManagedObjectContext
    private let coordinator: NSPersistentStoreCoordinator
    
    init(model: NSManagedObjectModel ) throws {
    
        let theCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model )
        let _ = try? theCoordinator.addPersistentStoreWithType( NSInMemoryStoreType,
                                                               configuration: nil,
                                                               URL: nil,
                                                               options: nil
        )
        
        coordinator = theCoordinator
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = coordinator
    }
    
    
    
    // insert
    func insertSongInDB (songItem: SongItem, context: NSManagedObjectContext) {
    
        let album = NSEntityDescription.insertNewObjectForEntityForName( Album.entityName, inManagedObjectContext: context) as? Album
        album?.title = songItem.album
      

        
        let artist =  NSEntityDescription.insertNewObjectForEntityForName(Artist.entityName, inManagedObjectContext: context) as? Artist
        artist?.fullname = songItem.artist
        artist?.url = songItem.artistUrl
        album?.artist = artist
      
        let track = NSEntityDescription.insertNewObjectForEntityForName(Track.entityName, inManagedObjectContext: context) as? Track
        track?.title = songItem.title
        track?.duration = songItem.songLength
        track?.price = songItem.price
        track?.album = album
        
        do {
        
            try self.mainContext.save()
        } catch let error {
            print("error save the song: \(error)")
        }
        
    }
    
    func deleteSongInDB(index: Int, context: NSManagedObjectContext) {
    
    }
    
}
