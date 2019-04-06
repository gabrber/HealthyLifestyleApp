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
    @IBOutlet weak var stepsGoal: UILabel!
    @IBOutlet weak var stepsGoalTime: UILabel!

    var stepsGoalData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        getStepsFromHK()
        getStepsGoal()
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
    private func getStepsGoal() {
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
            if stepsGoalData.count > 0
            {
                stepsGoal.text = String(stepsGoalData[0].value(forKey: "stepsGoal") as! Int)
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
    
    //private func getStepsGoal() {
    //
    //}

    // MARK: StepsViewActions
    
    @IBAction func authorizeHK(_ sender: UIButton) {
        authorizeHK()
    }
    
    @IBAction func getSteps(_ sender: UIButton) {
        getStepsFromHK()
    }

}
