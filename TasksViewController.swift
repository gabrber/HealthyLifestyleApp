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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "To do"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        test_dic()
    }
    
    func test_dic(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        //3
        do {
            try controller.performFetch()
            print(controller.sections!.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            cell.detailTextLabel?.text = "done"
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
    
    
//    func groupTasksByDate() {
//        Dictionary(grouping: myTasks) { (element) -> Date in
//            return element.value(forKeyPath: "dateTask")
//
//        }
//    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 5
//    }
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section: \(section)"
//    }
//
    // MARK: TasksActions
    

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Task",
                                      message: "Add a new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameToSave = textField.text else {
                                                return
                                        }
                                        
                                        self.save(name: nameToSave)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func save(name: String) {
        
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
        
        // 4
        do {
            try managedContext.save()
            myTasks.append(newTask)
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
    
}
