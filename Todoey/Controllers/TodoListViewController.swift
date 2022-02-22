//
//  ViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/01/22.
//

import UIKit

class TodoListViewController: UITableViewController {

    // making itemArray as an Item objetc array
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.tittle = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.tittle = "Buy Egos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.tittle = "Destroy Demogorgans"
//        itemArray.append(newItem3)
        
        loadItems()
        
        //set the item array to the array of user defaults to display the data which is newly added
//        if let items = defaults.array(forKey: "Todo list array") as? [Item]{
//            itemArray = items
//        }
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.tittle
        
        //var content = cell.defaultContentConfiguration()
        //content.text = itemArray[indexPath.row]
        //cell.contentConfiguration = content
        

//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        //using ternary operators for above code
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //MARK - Tableview Deligate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
        
        //Optional code for above if else statement
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        //checkmark is an accessory type
        //check wheather chekmark is present or not if yes then deselct the checkmark
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            //
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//
//        }
//        else{
//            //when we select a row it will apply checkmark next to it
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        //Deselects a row that an index path identifies, with an option to animate the deselection.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - add new items.
    //+ button adds item in the list(bar button item)
    @IBAction func addButtenPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { action in
            //what will happen once user clicks the add Item button on our UIAlert
            
            let newItem = Item()
            newItem.tittle = textField.text!
            
            self.itemArray.append(newItem)
            //setting new item into user defaults with forkey but cant store object
            //self.defaults.set(self.itemArray, forKey: "Todo list array")
            
            self.saveItems()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods.
    
    func saveItems() {
        //to store object inside item class plist
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding itemArray, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray, \(error)")
            }
        }
    }

}

