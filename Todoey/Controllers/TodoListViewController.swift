//
//  ViewController.swift
//  Todoey
//
//  Created by Yasin Cengiz on 19.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    var selectedCategory: ItemCategory? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    //MARK: - TableView DataSource Methods

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Adds a checkmark if true  -- Ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }

        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status --> \(error)")
            }
        }
        
        tableView.reloadData()
//      When a row is tapped gets rid of gray flashing
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    
    //MARK: - Add New Item

    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        // LOCAL VARIABLE FOR TEXTFIELD
        var textField = UITextField()
        
        // POP-UP FOR ADDING ITEM
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            // WHEN ADD ITEM BUTTON PRESSED
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items --> \(error)")
                }

            }
            
            self.tableView.reloadData()
            
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancelled")
        }))
        
        // ADDS A TEXT FIELD TO ADDBUTTON
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Adding alertTextField to local var textField so we can access what was written inside text field anywhere inside function
            textField = alertTextField
            
        }

        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: Add Item Text Field Trimming
    
    func title(with entry: String?) -> String {
        if let title = entry?.trimmingCharacters(in: .whitespacesAndNewlines), title.count > 0 {
            return title
        }
        return "New Item"
    }
    
    
    
    //MARK: - Model Manupilation Methods
    

//    func saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context --> \(error)")
//        }
//        self.tableView.reloadData()  // Reload data so added items show up
//    }
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    
}


//MARK: SearchBar Methods


extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }



}

