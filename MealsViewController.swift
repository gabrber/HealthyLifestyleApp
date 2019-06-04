//
//  MealsViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 15/05/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MealsViewController: UIViewController {

    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var wakeUpLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var mealsText: UITextView!
    
  
    @IBOutlet weak var editBar: UIToolbar!
    
    var mealsPlanData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealsText.centerVertically()
        editBar.setBackgroundImage(UIImage(),
                                    forToolbarPosition: .any,
                                    barMetrics: .default)
        editBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        mealsText.text = ""
        readMealsPlan()
        
    }
        
    private func readMealsPlan() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Meals")
        
        //3
        do {
            mealsPlanData = try managedContext.fetch(fetchRequest)
            //print(stepsGoalData.count)
            if mealsPlanData.count > 0
            {
                let meals = mealsPlanData[0].value(forKey: "meals") as! Int
                let wakeUp = mealsPlanData[0].value(forKey: "wakeUpTime") as! Date
                let sleep = mealsPlanData[0].value(forKey: "sleepTime") as! Date
                mealsLabel.text = convertMealsForLabel(mealsPerDay: meals)
                wakeUpLabel.text = convertDateFormatter(readHourInput: wakeUp)
                sleepLabel.text = convertDateFormatter(readHourInput: sleep)
                
                modifyMealsText(meals: meals, wakeUp: wakeUp, sleep:sleep)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func convertMealsForLabel(mealsPerDay :Int) -> String {
        let result = String(mealsPerDay)
        return result
    }
    
    func convertDateFormatter(readHourInput :Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // change format as per needs
        let result = formatter.string(from: readHourInput)
        return result
    }
    
    func calculateMealsTime(meals: Int, wakeUp: Date, sleep :Date) -> [String] {
        var mealsHourText :[String] = []
        
        var delta = Calendar.current.dateComponents([.second], from: wakeUp, to: sleep).second!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let currentDateTimeFrom = formatter.date(from: "2019/01/01 " + convertDateFormatter(readHourInput: wakeUp)) as! Date
        
        var dateToDay = ""
        if delta < 0 {
            dateToDay = "2019/01/02"
        } else {
            dateToDay = "2019/01/01"
        }
        
        let currentDateTimeTo = formatter.date(from: dateToDay + " " + convertDateFormatter(readHourInput: sleep)) as! Date
        
        delta = Calendar.current.dateComponents([.second], from: currentDateTimeFrom, to: currentDateTimeTo).second!
        var mealDelta = 0
        if meals != 0 {
            mealDelta = Int(delta/(meals+1))
        }
        
        for i in 1...meals {
            var mealToAppend = convertDateFormatter(readHourInput: Calendar.current.date(byAdding: .second, value: i*mealDelta, to: wakeUp)!)
            mealsHourText.append(mealToAppend)
        }
        
//        if delta < 0 {
//            mealsHourText.reverse()
//        }
        
        return mealsHourText
    }
    
    func modifyMealsText(meals: Int, wakeUp: Date, sleep :Date){
        var modifiedText = ""
        var mealsHourText :[String] = self.calculateMealsTime(meals: meals, wakeUp: wakeUp, sleep: sleep)
        for i in 1...meals {
            var mealTimeText = "\(i) meal     -     \(mealsHourText[i-1])\n\n"
            modifiedText.append(mealTimeText)
        }
        mealsText.text = modifiedText
        mealsText.centerVertically()
        
    }
    
    func setNotifications(notificationHours: [String]) {
        let center = UNUserNotificationCenter.current()
        for hour in notificationHours {
            var content = UNMutableNotificationContent()
            content.title = "BON APPETIT!"
            content.body = "It's a meal time. Don't miss it. It's importatnt part of a day."
            content.sound = UNNotificationSound.default
            // all app notifications go to the same group
            content.threadIdentifier = "local-notification hla"
            content.categoryIdentifier = "MEAL_TIME"
            
            var identifierHour = "MEAL_TIME" + hour
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let currentDateTimeFrom = formatter.date(from: hour) as! Date
            let dateNotify = Calendar.current.dateComponents([.hour, .minute], from: currentDateTimeFrom)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateNotify, repeats: true)
            let request = UNNotificationRequest(identifier: identifierHour, content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if error != nil {
                    print(error)
                }
            }
            
        }
    }

    func remove_meals_notifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                if request.content.categoryIdentifier == "MEAL_TIME" {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["identifier"])
                }
            }
        }
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editMealsSegue(segue: UIStoryboardSegue) {
        if segue.source is EditMealsViewController {
            if let senderMeals = segue.source as? EditMealsViewController {
                if senderMeals.ifUpdated {
                    mealsLabel.text = String(senderMeals.mealsCount)
                    wakeUpLabel.text = convertDateFormatter(readHourInput: senderMeals.wakeUpHour)
                    sleepLabel.text = convertDateFormatter(readHourInput: senderMeals.sleepHour)
                    self.modifyMealsText(meals: senderMeals.mealsCount,wakeUp: senderMeals.wakeUpHour,sleep: senderMeals.sleepHour)
                    
                    remove_meals_notifications()
                    var notificationHours = self.calculateMealsTime(meals: senderMeals.mealsCount,wakeUp: senderMeals.wakeUpHour,sleep: senderMeals.sleepHour)
                    setNotifications(notificationHours: notificationHours)
                }
            }
        }
    }

    
    
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
