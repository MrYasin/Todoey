//
//  ViewController.swift
//  Todoey
//
//  Created by Yasin Cengiz on 19.09.2019.
//  Copyright © 2019 MrYC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = ["Get laid","Kill all humans","Get money"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
    }

    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
//      When a row is tapped gets rid of gray flashing
        tableView.deselectRow(at: indexPath, animated: true)
        
//      Gives cell a checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
    }
    
    
    
    //MARK: - Add New Item
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        // LOCAL VARIABLE FOR TEXTFIELD
        var textField = UITextField()
        
        // POP-UP FOR ADDING ITEM
        
        let alert = UIAlertController(title: "Add New ToDo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

        // WHEN ADD ITEM BUTTON PRESSED
            
            if textField.text != nil {
                self.itemArray.append(textField.text!)
                self.defaults.set(self.itemArray, forKey: "TodoListArray")  // saves the data so when app is terminated and relaunched it shows up using Line 22 function
                self.tableView.reloadData()  // Reload data so added items show up
            } else {
                self.itemArray.append("New Item")
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                self.tableView.reloadData()  // Reload data so added items show up
            }
            
        }
        
//        CANCEL BUTTON
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
//            print("cancelled")
//        }
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
    
    
    
    

}

