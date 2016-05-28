//
//  MusicAlbumMachine.swift
//  MusicAlbumViewer
//
//  Created by Low Wai Hong on 5/28/16.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

import Foundation

enum InventoryError: ErrorType {
    case InvalidResource
    case ConversionError
    case InvalidKey
}

class MusicAlbumMachine{
    
    var inventory : [MusicAlbum]
    
    required init(inventory: [MusicAlbum]) {
        self.inventory = inventory
    }
}


//Helper Method
class PlistConverter {
    class func arrayFromFile(resource: String, ofType type: String) throws -> [NSDictionary] {
        
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw InventoryError.InvalidResource
        }
        
        guard let array = NSArray(contentsOfFile: path),
            let castArray = array as? [NSDictionary] else {
                throw InventoryError.ConversionError
        }
        
        return castArray
    }
}

class InventoryUnarchiver {
    class func inventoryFromArray(array:[NSDictionary]) throws -> [MusicAlbum] {
        
        var inventory: [MusicAlbum] = []
        
        for album in array{
            if let albumName = album["albumName"], let albumTrack = album["albumTrack"],
                let albumArtist = album["albumArtist"]{
                    let info = MusicAlbum(albumName: albumName as? NSString, albumTrack: albumTrack as? [NSString], albumArtist: albumArtist as? NSString)
                    inventory.append(info)
            }else{
                throw InventoryError.InvalidKey
            }
        }
        
        /*
        for (key, value) in dictionary {
            if let itemDict = value as? [String : Double],
                let price = itemDict["price"], let quantity = itemDict["quantity"] {
                    
                    let item = VendingItem(price: price, quantity: quantity)
                    
                    guard let key = VendingSelection(rawValue: key) else {
                        throw InventoryError.InvalidKey
                    }
                    
                    inventory.updateValue(item, forKey: key)
                    
            }
        }
        */
        
        return inventory
    }
}
