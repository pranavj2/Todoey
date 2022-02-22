//
//  item.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 21/02/22.
//

import Foundation
//Encodable+Decodable= Codable
//Encodable means Item type can encode itself into a plist or json
//and to work encodable, our class should have standard datatypes
class Item: Codable {
    var tittle : String = ""
    var done: Bool = false
}
