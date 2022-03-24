//
//  CategoryListTableViewController.swift
//  Todoey
//
//  Created by Sam Harris on 23/03/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

class CategoryListTableViewController: UITableViewController {

    var categories: [TodoCategory] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            categories = try context.fetch(TodoCategory.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToCategory", sender: indexPath.row)
    }

    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        var mTextField: UITextField = UITextField()
        let action = UIAlertAction(title: "Add Category", style: .default) {
            alertAction in
            if let newCategory = mTextField.text, newCategory != "" {
                
                let category = TodoCategory(context: self.context)
                category.name = newCategory

                do {
                    try self.context.save()
                    self.categories.append(category)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCategory" {
            let destination = segue.destination as! TodoListViewController
            destination.category = categories[sender as! Int]
        }
    }
}
