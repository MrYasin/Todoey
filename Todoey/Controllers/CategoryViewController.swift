//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yasin Cengiz on 21.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [ItemCategory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
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
             
             let newCategory = ItemCategory(context: self.context)
             
             newCategory.name = self.name(with: textField.text)
             
             self.categories.append(newCategory)
             self.saveCategories()
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
    
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context --> \(error)")
        }
        self.tableView.reloadData()  // Reload data so added items show up
    }
    
    func loadCategories(with request:NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context --> \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    
    
    
}


