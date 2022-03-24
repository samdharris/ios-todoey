//
//  TodoCategory.swift
//  Todoey
//
//  Created by Sam Harris on 24/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoCategory: Object {
    @Persisted var name: String = ""
    @Persisted var items: List<TodoItem>
}
