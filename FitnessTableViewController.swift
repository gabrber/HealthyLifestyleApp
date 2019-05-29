//
//  FitnessTableViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 06/05/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class FitnessTableViewController: UITableViewController {
    
    @IBOutlet var FitnessTableView: UITableView!
    
    let db = Firestore.firestore()
    var myFitness = [Fitness]()
    let storage = Storage.storage()
    var fitnessImages : [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100
        
        self.tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "FitnessCell")
        loadData()
        
    }
    
    func loadData() {
        db.collection("fitness").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.myFitness = querySnapshot!.documents.flatMap({Fitness(dictionary: $0.data())})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }
        }
    }
    
    func get_images() {
        for ex in self.myFitness{
            let storageRef = storage.reference(forURL: ex.image)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error occured")// Uh-oh, an error occurred!
                } else {
                    self.fitnessImages[ex.name] = UIImage(data: data!)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myFitness.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FitnessCell", for: indexPath)

        let exercise = myFitness[indexPath.row]
        cell.textLabel?.text = "\(exercise.name)"
            
        // Placeholder image
        let reference = storage.reference(forURL: exercise.image)
        let placeholderImage = UIImage(named: exercise.name)
        cell.imageView!.sd_setImage(with: reference, placeholderImage: placeholderImage)
//        cell.imageView?.image = fitnessImages[exercise.name]
        return cell
    }
    
}
