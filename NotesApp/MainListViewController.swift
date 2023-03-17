//
//  ViewController.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/13/23.
//

import UIKit
import CoreData

class MainListViewController: UITableViewController {

    var itemArray = [Item]()

    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Print location where data is stored for the programmer's reference
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }

    //MARK:- TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
    
        mainCell.textLabel?.text = item.title
        
        //Save Array to plist (Local Storage)
        mainCell.accessoryType = item.done ? .checkmark : .none
        
        return mainCell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //For deleting cells, make sure that the itemArray checkmarks are commented first.
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
        // Unselect the row, and instead, show the state with a checkmark.
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add Items

    @IBAction func addItemToMainList(_ sender: Any) {
                
        var textfield = UITextField()
        let alert = UIAlertController(title: "This is the Title", message: "This is the message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
        
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.saveItems()
            
        }

        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
    }
    

    //MARK - Model Manupulation Methods
    
    func saveItems() {
        
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            //Returns an NSFetchqRequest which is an array of "Items"
            itemArray = try context.fetch(request)
        }
        catch{
        }
        tableView.reloadData()
    }
    

//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
}

extension MainListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        // Make Query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        //Sort query to ascending
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        //Basic load data using Coredata
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("Error fetching search request")
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

