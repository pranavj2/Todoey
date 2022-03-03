//
//  Category.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/02/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //Forward relationship
    let items = List<Item>()

}
