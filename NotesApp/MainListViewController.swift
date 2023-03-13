//
//  ViewController.swift
//  NotesApp
//
//  Created by Jao Garcia on 3/13/23.
//

import UIKit

class MainListViewController: UITableViewController {

    let itemArray = ["Buy Eggs", "Buy Milk", "Buy Corn"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK:- TableView Data Source Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainCell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
        
        mainCell.textLabel?.text = itemArray[indexPath.row]
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
    

}

