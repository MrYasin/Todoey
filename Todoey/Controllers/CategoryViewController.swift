//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yasin Cengiz on 21.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<ItemCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If categories is nil not nil return count -- if nil return 1
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "003366")

        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add Button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // LOCAL VARIABLE FOR TEXTFIELD
        var textField = UITextField()
        
        // POP-UP FOR ADDING ITEM
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            // WHEN ADD ITEM BUTTON PRESSED
            
            let newCategory = ItemCategory()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancelled")
        }))
        
        // ADDS A TEXT FIELD TO ADDBUTTON
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            // Adding alertTextField to local var textField so we can access what was written inside text field anywhere inside function
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }


    //MARK: Add Item Text Field Trimming
    
    func name(with entry: String?) -> String {
        if let name = entry?.trimmingCharacters(in: .whitespacesAndNewlines), name.count > 0 {
            return name
        }
        return "New Item"
    }
    
    
    //MARK: - Model Manupilation Methods
    
    
    func save(category: ItemCategory) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context --> \(error)")
        }
        tableView.reloadData()  // Reload data so added items show up
    }
    
    
    func loadCategories() {
        
        categories = realm.objects(ItemCategory.self)
        tableView.reloadData()
        
    }
    
    
    override func updateModel(at IndexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[IndexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category --> \(error)")
            }

        }
    }
    
    
    
    
}



