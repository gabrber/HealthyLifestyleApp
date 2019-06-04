//
//  EditMealsViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 04/06/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import CoreData

class EditMealsViewController: UIViewController {

    @IBOutlet weak var mealsNumb: UITextField!
    @IBOutlet weak var wakeUpTime: UIDatePicker!
    @IBOutlet weak var sleepTime: UIDatePicker!
    
    var ifUpdated = false
    var mealsCount :Int!
    var wakeUpHour :Date!
    var sleepHour :Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func updateMealsCoreData(mealsCount: Int, wakeUpHour: Date, sleepHour: Date){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Meals",
                                       in: managedContext)!
        
        // 3
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Meals")
        
        //3
        do {
            let stepsGoalData = try managedContext.fetch(fetchRequest)
            if stepsGoalData.count > 0
            {
                let objectUpdate = stepsGoalData[0]
                objectUpdate.setValue(mealsCount, forKeyPath: "meals")
                objectUpdate.setValue(wakeUpHour, forKey: "wakeUpTime")
                objectUpdate.setValue(sleepHour, forKey: "sleepTime")
            }
            else{
                let updatedSteps = NSManagedObject(entity: entity,
                                                   insertInto: managedContext)
                updatedSteps.setValue(mealsCount, forKeyPath: "meals")
                updatedSteps.setValue(wakeUpHour, forKey: "wakeUpTime")
                updatedSteps.setValue(sleepHour, forKey: "sleepTime")
            }
            ifUpdated = true
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
    
    func updateMealsPlan() {
        if let readUserInputMeals = Int(mealsNumb.text!) {
            mealsCount = Int(mealsNumb.text!)
            wakeUpHour = wakeUpTime.date
            sleepHour = sleepTime.date
            updateMealsCoreData(mealsCount: mealsCount, wakeUpHour: wakeUpHour, sleepHour: sleepHour)
        }
        else {
            print("Wrong users input")
        }
    }
    

    @IBAction func saveMeal(_ sender: UIButton) {
        self.updateMealsPlan()
        performSegue(withIdentifier: "editMealsSegue", sender: self)
    }
    
    @IBAction func cancelMeal(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
