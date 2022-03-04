//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 24/02/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    //1.We initialized new accesspoitn for realm database
    let realm = try! Realm()

        //2.We changed our categories from an array of category items to this new "collection type".
    var categories: Results<Category>?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //3.we load up all the categories that we own.
        loadCategories()
    }

    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //**nil coalescing Operator(OPTIONAL CHAINING.)**
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
    //10. We pass in new category that we created
    func save(category: Category) {
        do {
            //11. We call realm.write to commit some changes to our realm.
            try realm.write{
                //12.the change is we want to add our new category to our database
                realm.add(category)
            }
        }catch {
            //13. We log if there any errors.
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        //4.We set that property categories to look inside our realm and fetch all objects that belong to category data type.
        categories = realm.objects(Category.self)
        
        //5.We reload table view with new data (which will call all the data source methods again)
        tableView.reloadData()
        
    }
    
    
    //MARK: - Data New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        //6.we have "Add" button for creation of categorty
        let action = UIAlertAction(title: "Add", style: .default) { action in
            //7.After clicking on add button we create new category object
            let newCategory = Category()
            //8. We give that object a name as user types in textfield at runtime.
            newCategory.name = textField.text!
            //9. We save the category inside realm
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
    //14. when we click on  a cell we call "didSelectRowAt indexPath" method which performs a segue that will take the user to TodoListViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //achieved by using segues
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue.destination property is downcasted to TodoListViewController using as!
        //15. Before going to TodoListViewController We create a new object of our destinationVC
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //16. And we set destinationVC.selectedCategory to the category at the index path that was selected.
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
}
