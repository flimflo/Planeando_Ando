//
//  Category.swift
//  ToDoL
//
//  Created by Fernando Limón Flores on 10/7/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
