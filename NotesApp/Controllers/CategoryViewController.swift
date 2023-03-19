//
//  CategoryViewController.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/19/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Model Location
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //Initial Load of coreData File
        loadCategory()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let categoryItem = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryItem.name

        return cell
    }
    

    //MARK: - Data Manipulation Methods
    //Save using COREDATA
    func saveCategory(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    
    }
        
    //Load using COREDATA
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading the data: \(error)")
        }
        tableView.reloadData()
    }

    //MARK: - Add New Categories
    @IBAction func addCategory(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "Please input a category", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category Item", style: .default) { (action) in
            
            // Grab the model using the context
            let newCategory = Category(context: self.context)
            //Set variables in the model
            newCategory.name = textfield.text!
            //Append the new object to the array
            self.categoryArray.append(newCategory)
            //Save in coreData
            self.saveCategory()
            //Reload for every Add Category Press
            self.tableView.reloadData()
            
        }
        //Perform Textfield Setup
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new Category"
            textfield = alertTextfield
        }
        //Execute Action
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    //MARK: - Data manipulation methods

}
