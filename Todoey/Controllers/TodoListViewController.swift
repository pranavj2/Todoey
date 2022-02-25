//
//  ViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/01/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    // making itemArray as an Item objetc array
    var itemArray = [Item]()
    
    //when we get new value for selectedCategory variable, loadItems() gets called
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //we able to access a singletone which is UIApplication.shared and get its delegate property as an app delegate in order to tap into persistentContainer which is a lazy variable.
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //to get the stored data location from core data
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
                
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
        
        
//        loadItems()
        
        //set the item array to the array of user defaults to display the data which is newly added
//        if let items = defaults.array(forKey: "Todo list array") as? [Item]{
//            itemArray = items
//        }
    }
    
    //MARK: - Tableview Datasource Methods
    
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
    
    //MARK: - Tableview Deligate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//        //item deleted from database
//        context.delete(itemArray[indexPath.row])
//
//        //item deleted from array
//        itemArray.remove(at: indexPath.row)
        
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
    
    
    //MARK: - add new items.
    //+ button adds item in the list(bar button item)
    @IBAction func addButtenPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Items", style: .default) { action in
            
            //what will happen once user clicks the add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.tittle = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    //success fully added data into core data model
    func saveItems() {
        //to store object inside item class plist
//        let encoder = PropertyListEncoder()
        
        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
           try context.save()
            
        }catch{
//            print("Error encoding itemArray, \(error)")
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
   
    
    
    //MARK: - LoadItems method here.
    //successfully fetched data from database to screen
    //"with" is an external parameter and request is an internal parameter
    // "Item.fetchRequest()" is the default value when we call function without parameters
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPreidcate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPreidcate, predicate])
//
//        request.predicate = compoundPredicate
        
        //writting above code using optional binding
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPreidcate, additionalPredicate])
        }else{
            request.predicate = categoryPreidcate
        }
        
        request.predicate = predicate
        
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
    

}
//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    //to search item from list
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //NSPredicate allows us to fire query for database inside swift code
        //searchBar variable will take postion of %@ and [cd] is to make query case insensitive
        let predicate = NSPredicate(format: "tittle CONTAINS[cd] %@", searchBar.text!)
        
        //to sort the data which we get from database
        request.sortDescriptors = [NSSortDescriptor(key: "tittle", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    //this method helps to go back to the list after clicking x symbol
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            //assigns processes to different threads
            DispatchQueue.main.async {
                //deselect the search bar and removes keypad from screen as soon as we click on x
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
