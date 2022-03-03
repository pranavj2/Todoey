//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 24/02/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    //Results is a container in Realm returned from object queries and it will contain a bunch of category objects
    //It is simply autoupdating container and monitors the items
    var categories: Results<Category>?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //**nil coalescing Operator**
        //? - If categories is not nil then return categories.count
        //?? - If it is nil return 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates a reusable cell and adds it to the index path.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //add data into the database
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added!!"
        
        return cell
        
    }
    
    
    
    //MARK: - Data Manipulation methods
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        //this will pull out all the items from realm
        categories = realm.objects(Category.self)

        tableView.reloadData()
        
    }
    
    
    //MARK: - Data New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - TableView Delegate methods
    //methods to go from Category list top Item view when user clicks on Category items.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //achieved by using segues
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue.destination property is downcasted to TodoListViewController using as!
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
}
