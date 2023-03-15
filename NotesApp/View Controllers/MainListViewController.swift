//
//  ViewController.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/13/23.
//

import UIKit

//Summary:
// If you want to save data locally, and them items you want to save are based on a struct model, you can make your struct as a Codable (That is encodable and decodable). This would be an efficient transmission of storage when it comes to saving and loading data in your device)

//Good For: Cells with a few properties
//Not Good For: High number of array items, as it would load up all the data at the same time
//Applications: Saving notes, usernames and other basic data

class MainListViewController: UITableViewController {

    //CodableBranch:
    var itemArray = [MainItem]() //Create an array of your struct
    
    //Path where data is stored (appendingPathComponent creates the file if it does not exist yet)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
               
        //Start.Test: - For testing purposes only (so that we can view if cells are properly shown in the table view
//        var newItem = MainItem()
//        newItem.itemName = "Test Item 1"
//        itemArray.append(newItem)
//
//        var newItemTwo = MainItem()
//        newItemTwo.itemName = "Test Item 2"
//        itemArray.append(newItemTwo)
        //End.Test:
                
        //Load existing items stored in the plist
        loadItems()
    }

    //MARK:- TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
        mainCell.textLabel?.text = itemArray[indexPath.row].itemName
        
        //Display Checkmarks in reference to what is stored in the plist
        if itemArray[indexPath.row].checked {
            mainCell.accessoryType = .checkmark
        } else {
            mainCell.accessoryType = .none
        }
        return mainCell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect the row upon clicking
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Set the opposite of current state of checkmarks when clicked in the plist
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        //Save checkmark state
        saveItems()
    
        tableView.reloadData()
    
    }
    
    //MARK: - Add Items
    @IBAction func addItemToMainList(_ sender: Any) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "This is the Title", message: "This is the message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //What is inputted in the text field must be added to the itemArray
            var newItem = MainItem()
            newItem.itemName = textfield.text!
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
        }
        
        //Alert texts and presentation
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Save Data Locally (Encodable)
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding itemarray, \(error)")
        }
        
    }
    
    //Load Data Locally (Decodable)
    func loadItems(){
        //Load data from File Path
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([MainItem].self, from: data)
            } catch{
                print("Error decoding: \(error)")
            }
        }
    }

}

