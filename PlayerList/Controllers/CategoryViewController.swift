//
//  CategoryViewController.swift
//  PlayerList
//
//  Created by Johni7 on 14/03/2019.
//  Copyright © 2019 Sammel. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategorys()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
//        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].club
        
//        cell.accessoryType = player.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        categoryArray[indexPath.row].done = !categoryArray[indexPath.row].done
        
        saveCategorys()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK: - TableView Datasource Methods
    
    //MARK: - Data Manipulation Methods
    
    //MARK: - Add Mew Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Club", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.club = textField.text!
//            newPlayer.done = false
            
            self.categoryArray.append(newCategory)
            
            self.saveCategorys()
            
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create New Club"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
    func saveCategorys() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategorys(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    //MARK: - TableView Delegate Methods
    
}
