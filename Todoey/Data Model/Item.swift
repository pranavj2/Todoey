//
//  Item.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/02/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //Reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    }
