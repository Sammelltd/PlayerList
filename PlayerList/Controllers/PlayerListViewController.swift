//
//  ViewController.swift
//  PlayerList
//
//  Created by Johni7 on 09/03/2019.
//  Copyright © 2019 Sammel. All rights reserved.
//

import UIKit
import CoreData

class PlayerListViewController: UITableViewController {
    
    var playerArray = [Player]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadPlayers()
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerListItemCell", for: indexPath)
        
        let player = playerArray[indexPath.row]
        
        cell.textLabel?.text = player.title

        cell.accessoryType = player.done ? .checkmark : .none
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        playerArray[indexPath.row].done = !playerArray[indexPath.row].done

        savePlayers()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Player", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            let newPlayer = Player(context: self.context)
            
            newPlayer.title = textField.text!
            newPlayer.done = false
            
            self.playerArray.append(newPlayer)
            
            self.savePlayers()
            
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create New Player"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func savePlayers() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadPlayers(with request: NSFetchRequest<Player> = Player.fetchRequest()) {

        do {
            playerArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension PlayerListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Player> = Player.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadPlayers(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadPlayers()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
