//
//  Item.swift
//  Todoey
//
//  Created by Yasin Cengiz on 22.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: ItemCategory.self, property: "items")

}



