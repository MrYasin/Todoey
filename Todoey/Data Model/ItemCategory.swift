//
//  Category.swift
//  Todoey
//
//  Created by Yasin Cengiz on 22.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import Foundation
import RealmSwift

class ItemCategory: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""

    let items = List<Item>()
}
