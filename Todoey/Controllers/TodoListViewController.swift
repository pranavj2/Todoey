//
//  ViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/01/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    // making itemArray as an Item objetc array
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    //when we get new value for selectedCategory variable, loadItems() gets called
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        //using ternary operators for above code
        cell.accessoryType = item.done ? .checkmark : .none
            
        }else {
            cell.textLabel?.text  = "No items Aded!"
        }
        
        return cell
    }
    
    //MARK: - Tableview Deligate Methods.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if todoItems is not nil pick the item at indexPath.row and set it equal to item
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
                
            }catch {
                    print("Error Saving done status \(error)")
            }
        }
        
        tableView.reloadData()
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        
//        saveItems()

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
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once user clicks the add Item button on our UIAlert

               if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            currentCategory.items.append(newItem)
                        }
                    }catch {
                    print("Error saving new items, \(error)")
                }
               }
                self.tableView.reloadData()
        
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Create new Item"
                textField = alertTextField
            }
            alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
        }
    

    //MARK: - LoadItems method here.
    //successfully fetched data from database to screen
    //"with" is an external parameter and request is an internal parameter
    // "Item.fetchRequest()" is the default value when we call function without parameters
    func loadItems() {
        //items loaded in selectedCategory variable will be sorted in ascending manner
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}

//MARK: - Search bar methods

//extension TodoListViewController: UISearchBarDelegate {
//    //to search item from list
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //NSPredicate allows us to fire query for database inside swift code
//        //searchBar variable will take postion of %@ and [cd] is to make query case insensitive
//        let predicate = NSPredicate(format: "tittle CONTAINS[cd] %@", searchBar.text!)
//
//        //to sort the data which we get from database
//        request.sortDescriptors = [NSSortDescriptor(key: "tittle", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    //this method helps to go back to the list after clicking x symbol
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            //assigns processes to different threads
//            DispatchQueue.main.async {
//                //deselect the search bar and removes keypad from screen as soon as we click on x
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//}
//}
