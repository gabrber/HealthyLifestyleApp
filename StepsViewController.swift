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
import UserNotifications
import MBCircularProgressBar

let healthKitStore:HKHealthStore = HKHealthStore()

class StepsViewController: UIViewController {
  
    // MARK: StepsViewProperties
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var stepsGoalTime: UILabel!
    @IBOutlet weak var stepsGoalCount: UILabel!
    
    var stepsGoalData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        // Do any additional setup after loading the view.
        authorizeHK()
        getStepsFromHK()
        readStepsGoal()
        
    }
    
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
                self.progressBar.maxValue = CGFloat(stepsGoalData[0].value(forKey: "stepsGoal") as! Int)
//                self.progressBar.unitString = "\n / " + String(stepsGoalData[0].value(forKey: "stepsGoal") as! Int)
//                self.progressBar.showUnitString = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
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
                //self.stepsNumber.text = String(stepsTaken)
                self.progressBar.value = CGFloat(stepsTaken)
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
    
    func setStepsNotification(timeGoal :Date) {
        let center = UNUserNotificationCenter.current()
        var content = UNMutableNotificationContent()
        content.title = "Let's exercise!"
        
        content.body = "Check if your steps goal was reached today"
        content.sound = UNNotificationSound.default
        // all app notifications go to the same group
        content.threadIdentifier = "local-notification hla"
        content.categoryIdentifier = "CHECK_STEPS"

        let dateNotify = Calendar.current.dateComponents([.hour, .minute], from: timeGoal)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateNotify, repeats: true)
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
        //let stepsTaken = stepsNumber.text!
        let stepsToTake = stepsGoalCount.text!
        
        center.add(request) { (error) in
            if error != nil {
                print(error)
            }
        }
    }

    // MARK: StepsViewActions
    
    @IBAction func unwindToSteps(segue: UIStoryboardSegue) {
        if segue.source is StepsGoalViewController {
            if let senderSteps = segue.source as? StepsGoalViewController {
                if senderSteps.ifUpdated {
                    stepsGoalCount.text = String(senderSteps.sagueCount)
                    stepsGoalTime.text = convertDateFormatter(readHourInput: senderSteps.sagueDate)
                    self.progressBar.maxValue = CGFloat(senderSteps.sagueCount)
                    self.setStepsNotification(timeGoal: senderSteps.sagueDate)
                }
            }
        }
    }

}
