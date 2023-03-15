//
//  ViewController.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/13/23.
//

import UIKit

class MainListViewController: UITableViewController {

    //CodableBranch

    var itemArray = ["Buy Eggs", "Buy Milk", "Buy Corn"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Load pList
        if let items = defaults.array(forKey: "mainListArray") as? [String]{
            itemArray = items
        }
    }

    //MARK:- TableView Data Source Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
        
        mainCell.textLabel?.text = itemArray[indexPath.row]
        
        //Save Array to plist (Local Storage)
        self.defaults.set(self.itemArray,forKey: "mainListArray")
        
        return mainCell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row, and instead, show the state with a checkmark.
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.accessoryType == .checkmark{
            cell.accessoryType = .none
        } else{
            cell.accessoryType = .checkmark
        }
    }
    
    //MARK: - Add Items

    @IBAction func addItemToMainList(_ sender: Any) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "This is the Title", message: "This is the message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textfield.text!)
            self.tableView.reloadData()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

