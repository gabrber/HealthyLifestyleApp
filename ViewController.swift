//
//  ViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 12/03/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var fitnessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let center = UNUserNotificationCenter.current()
        var content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.subtitle = "Just subtitle"
        content.body = "Hi! Welcome to HealthyLifestyleApp"
        content.sound = UNNotificationSound.default
        // all app notifications go to the same group
        content.threadIdentifier = "local-notification temp"
        
        //let date = Date(timeIntervalSinceNow: 10)
        //let dateNotify = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        var dateNotify = DateComponents()
        dateNotify.second = 0
        //dateNotify.minute = 0
        //dateNotify.hour = 23
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateNotify, repeats: false)
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateNotify, repeats: true)
        
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print(error)
            }
        }
        
    }

    // MARK: Actions
    
    @IBAction func goToTasks(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func goToSteps(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func goToMeals(_ sender: UITapGestureRecognizer) {
    }
    @IBAction func goToFitness(_ sender: UITapGestureRecognizer) {
    }
}

