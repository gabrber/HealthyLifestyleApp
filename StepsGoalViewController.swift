//
//  StepsGoalViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 06/04/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import CoreData

class StepsGoalViewController: UIViewController {

    @IBOutlet weak var stepsGoalText: UITextField!
    @IBOutlet weak var stepsGoalTime: UIDatePicker!
    
    var stepsNumber = 0
//    var doneSaving: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks.
    }
    
    //MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func updateStepsGoalCoreData(stepsNumber: Int, stepsTime: Date){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        
        let entity =
            NSEntityDescription.entity(forEntityName: "Steps",
                                       in: managedContext)!
        
        // 3
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Steps")
        
        //3
        do {
            let stepsGoalData = try managedContext.fetch(fetchRequest)
            if stepsGoalData.count > 0
            {
                let objectUpdate = stepsGoalData[0]
                objectUpdate.setValue(stepsNumber, forKeyPath: "stepsGoal")
                objectUpdate.setValue(stepsTime, forKey: "timeGoal")
            }
            else{
                let updatedSteps = NSManagedObject(entity: entity,
                                                   insertInto: managedContext)
                updatedSteps.setValue(stepsNumber, forKeyPath: "stepsGoal")
                updatedSteps.setValue(stepsTime, forKey: "timeGoal")
            }
        } catch let error as NSError {
            print("Error while updating steps goal (error), \(error.userInfo)")
        }
        
        // 4
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateStepsGoal() {
        if let readUserInputSteps = Int(stepsGoalText.text!) {
            updateStepsGoalCoreData(stepsNumber: readUserInputSteps, stepsTime: stepsGoalTime.date)
        }
        else {
            print("Wrong users input")
        }
    }
        
    //MARK: Steps Goals Edit Actions
    
    @IBAction func saveStepsGoal(_ sender: UIButton) {
        self.updateStepsGoal()
//        if let doneSaving = doneSaving {
//            doneSaving()
//        }
        dismiss(animated: true)
        
    }
    
    @IBAction func cancelStepsGoal(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
