//
//  TodoItem.swift
//  Todoey
//
//  Created by Sam Harris on 24/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @Persisted var name: String
    @Persisted var completed: Bool
    @Persisted var parentCategory = LinkingObjects(fromType: TodoCategory.self, property: "items")
}
