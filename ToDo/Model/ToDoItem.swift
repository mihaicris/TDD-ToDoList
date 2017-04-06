//
//  ToDoItem.swift
//  ToDo
//
//  Created by Mihai Cristescu on 27/03/2017.
//  Copyright © 2017 Mihai Cristescu. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    fileprivate let titleKey = "titleKey"
    fileprivate let itemDescriptionKey = "itemDescriptionKey"
    fileprivate let timestampKey = "timestampKey"
    fileprivate let locationKey = "locationKey"

    
    init(title: String,
         itemDescription: String? = nil,
         timestamp: Double? = nil,
         location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    var plistDict: [String: Any] {
        var dict: [String: Any] = [:]
        
        dict[titleKey] = title
        
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        
        if let location = location {
            dict[locationKey] = location.plistDict
        }
        
        return dict
    }
}

extension ToDoItem {
    
    init?(dict: [String: Any]) {
        guard let title = dict[titleKey] as? String else {
            return nil
        }
        
        self.title = title
        
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        
        if let locationDict = dict[locationKey] as? [String: Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }
}

func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    if lhs.location != rhs.location ||
       lhs.timestamp != rhs.timestamp ||
       lhs.itemDescription != rhs.itemDescription ||
       lhs.title != rhs.title {
        return false
    }
    return true
}
