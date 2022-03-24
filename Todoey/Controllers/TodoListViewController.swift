//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var category: TodoCategory?
    var items: [TodoItem] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var searchBar: UISearchBar!
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        var mTextField: UITextField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) {
            alertAction in
            if let newTodo = mTextField.text, newTodo != "" {
                
                let todo = TodoItem(context: self.context)
                todo.completed = false
                todo.name = newTodo
                todo.parentCategory = self.category!

                do {
                    try self.context.save()
                    self.items.append(todo)
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
        let request = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory = %@", category!)
        do {
            items = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemIdentifier", for: indexPath)
        let item = items[indexPath.row] as TodoItem
        cell.textLabel?.text = item.name
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].completed = !items[indexPath.row].completed

        do {
            try context.save()
            UIView.animate(withDuration: 0.5, animations: { self.tableView.deselectRow(at: indexPath, animated: true) }) {
                _ in
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - Search Bar Stuff
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = TodoItem.fetchRequest()
        if let query = searchBar.text, query != "" {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", query)
        }
        
        do {
            let results = try self.context.fetch(request)
            items = results
            tableView.reloadData()
        } catch {
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            do {
                let results = try self.context.fetch(TodoItem.fetchRequest())
                items = results
                tableView.reloadData()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } catch {
                
            }
        }
    }
}
