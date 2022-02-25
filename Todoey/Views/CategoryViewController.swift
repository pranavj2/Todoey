//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 24/02/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    //Array of Category objects and initializing it as an empty array.
    var categories = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates a reusable cell and adds it to the index path.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //add data into the database
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    
    
    //MARK: - Data Manipulation methods
    func saveCategories() {
        do {
        try context.save()
        }catch {
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
        try context.fetch(request)
        }catch {
            print("Error loading Category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Data New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    
    
}
