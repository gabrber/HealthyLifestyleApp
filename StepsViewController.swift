//
//  StepsViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 24/03/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import HealthKit
import CoreData

let healthKitStore:HKHealthStore = HKHealthStore()

class StepsViewController: UIViewController {
  
    // MARK: StepsViewProperties
    
    @IBOutlet weak var stepsNumber: UILabel!
    @IBOutlet weak var stepsGoalTime: UILabel!
    @IBOutlet weak var stepsGoalCount: UILabel!
    
    var stepsGoalData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        getStepsFromHK()
        readStepsGoal()
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
    private func readStepsGoal() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Steps")
        
        //3
        do {
            stepsGoalData = try managedContext.fetch(fetchRequest)
            //print(stepsGoalData.count)
            if stepsGoalData.count > 0
            {
                stepsGoalCount.text = convertStepsForLabel(stepsToTake: stepsGoalData[0].value(forKey: "stepsGoal") as! Int)
                stepsGoalTime.text = convertDateFormatter(readHourInput: stepsGoalData[0].value(forKey: "timeGoal") as! Date)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toStepsGoalSegue" {
//            let popup = segue.destination as! StepsGoalViewController
//            popup.doneSaving = {
//                self.viewDidAppear(true)
//            }
//        }
//    }
    
    // MARK: StepsViewFunctions
    
    private func authorizeHK() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
    private func getStepsFromHK() {

        HealthKitDataStore.getTodaysSteps { (stepsTaken) in
            DispatchQueue.main.async {
                self.stepsNumber.text = String(stepsTaken)
            }
        }
    }
    
    func convertDateFormatter(readHourInput :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // change format as per needs
        let result = formatter.string(from: readHourInput)
        return result
    }
    
    func convertStepsForLabel(stepsToTake :Int) -> String {
        let result = String(stepsToTake)
        return result
    }

    // MARK: StepsViewActions
    
    @IBAction func unwindToSteps(segue: UIStoryboardSegue) {
        if segue.source is StepsGoalViewController {
            if let senderSteps = segue.source as? StepsGoalViewController {
                if senderSteps.ifUpdated {
                    stepsGoalCount.text = String(senderSteps.sagueCount)
                    stepsGoalTime.text = convertDateFormatter(readHourInput: senderSteps.sagueDate)
                }
            }
        }
    }
    
    @IBAction func authorizeHK(_ sender: UIButton) {
        authorizeHK()
    }
    
    @IBAction func getSteps(_ sender: UIButton) {
        getStepsFromHK()
    }

}
