//
//  CategoryViewController.swift
//  ToDoL
//
//  Created by Fernando Limón Flores on 9/22/19.
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor , isFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will hapen if user clicks the Add Item button in UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = (UIColor.randomFlat()?.hexValue())!
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField.placeholder = "Add a new category"
            textField = field
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Manipulation Methods
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch{
                print("Error deleting category, \(error)")
            }
        }
    }
}
