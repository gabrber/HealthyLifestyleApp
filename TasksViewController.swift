//
//  TasksViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 01/04/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseUI

class TasksViewController: UITableViewController {
    

    var myTasks: [NSManagedObject] = []
    let storage = Storage.storage()
    var tasksCategories: [String] = ["idea","shopping","books","travel","work","home","gym","relax","nature","food","other","people"]
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "To do"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
    }
      
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()

    }
    
    func getData(){
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateTask", ascending: true)]
        
        //3
        do {
            myTasks = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    //return the number of rows in the table as the number of myTasks items
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return myTasks.count
    }
    
    //dequeue table view cells and populate them with the corresponding string from myTasks
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let myTask = myTasks[indexPath.row]
            var cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.layoutMargins = UIEdgeInsets.zero
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel?.text = myTask.value(forKeyPath:"name") as? String
            cell.detailTextLabel?.isEnabled = true
            cell.detailTextLabel?.text = formatter.string(from: (myTask.value(forKeyPath:"dateTask") as! Date))
            cell.imageView!.image = UIImage(named: "idea.png")
            cell.imageView?.contentMode = .center
            return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.delete(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func save(name: String, date: Date, category: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Task",
                                       in: managedContext)!
        
        let newTask = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        newTask.setValue(name, forKeyPath: "name")
        newTask.setValue(category, forKeyPath: "typeTask")
        newTask.setValue(date, forKeyPath: "dateTask")
        
        // 4
        do {
            try managedContext.save()
            //myTasks.append(newTask)
            getData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(indexPath: IndexPath) {

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext

        // 2
        managedContext.delete(myTasks[indexPath.row])

        // 3
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        // 4
        do {
            myTasks = try managedContext.fetch(Task.fetchRequest())
        } catch  let error as NSError {
            print(error.userInfo)
            print("Fetching Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addNewTaskSegue") {
            let destination = segue.destination as? AddTaskViewController
            var tableIndex = self.tableView.indexPathForSelectedRow?.row
            destination?.tasksCategories = tasksCategories
        }
    }
    
    @IBAction func unwindToTaskView(segue: UIStoryboardSegue) {
        if segue.source is AddTaskViewController {
            if let newTaskToAdd = segue.source as? AddTaskViewController {
                if newTaskToAdd.ifUpdated {
                    var name = newTaskToAdd.taskName
                    var date = newTaskToAdd.taskDate!
                    var categ =  newTaskToAdd.taskCategory
                    save(name: name, date: date, category: categ)
                    tableView.reloadData()
                }
            }
        }
    }
    
}
