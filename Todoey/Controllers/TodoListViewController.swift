//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var category: TodoCategory?
    var items: Results<TodoItem>?

    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        var mTextField: UITextField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) {
            alertAction in
            if let newTodo = mTextField.text, newTodo != "" {
                
                let todo = TodoItem()
                todo.completed = false
                todo.name = newTodo
                
                do {
                    try self.realm.write {
                        self.category?.items.append(todo)
                        self.realm.add(todo)
                    }
                    self.tableView.reloadData()
                }  catch {
                    print(error)
                }
            }
        }
        
        alert.addTextField {
            textField in
            mTextField = textField
            textField.placeholder = "Todo name"
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.navigationItem.title = category?.name
        items = category?.items.sorted(byKeyPath: "name", ascending: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemIdentifier", for: indexPath)
        let item = items?[indexPath.row] as? TodoItem
        if item != nil {
            cell.textLabel?.text = item!.name
            cell.accessoryType = item!.completed ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.completed = !item.completed
                }
                self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Search Bar Stuff
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, query != "" {
            items = items?.filter("name CONTAINS[cd] %@", query)
            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            items = category?.items.sorted(byKeyPath: "name", ascending: true)
            tableView.reloadData()
        }
    }
}
