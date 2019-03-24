//
//  StepsViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 24/03/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import HealthKit

let healthKitStore:HKHealthStore = HKHealthStore()

class StepsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getStepsFromHK()
    }
    
    // MARK: StepsViewProperties
    
    @IBOutlet weak var stepsNumber: UILabel!
    
    
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

    // MARK: StepsViewActions
    
    @IBAction func authorizeHK(_ sender: UIButton) {
        authorizeHK()
    }
    
    @IBAction func getSteps(_ sender: UIButton) {
        getStepsFromHK()
    }
    
}
