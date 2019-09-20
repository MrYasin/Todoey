//
//  ViewController.swift
//  Todoey
//
//  Created by Yasin Cengiz on 19.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import UIKit


class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(dataFilePath)
        
        loadItems()
    
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
//      Adds a checkmark if true  -- Ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
//      If .done property is true it becomes false vice versa
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
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
            
            let newItem = Item()
            newItem.title = self.title(with: textField.text)
            self.itemArray.append(newItem)
            self.saveItems()
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancelled")
        }))
        
        // ADDS A TEXT FIELD TO ADDBUTTON BITTON
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // Adding alertTextField to local var textField so we can access what was written inside text field anywhere inside function
            textField = alertTextField
            
        }

        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Model Manupilation Methods
    
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()  // Reload data so added items show up
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    // Add item text field
    
    func title(with entry: String?) -> String {
        if let title = entry?.trimmingCharacters(in: .whitespacesAndNewlines), title.count > 0 {
            return title
        }
        return "New Item"
    }
    
  
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

