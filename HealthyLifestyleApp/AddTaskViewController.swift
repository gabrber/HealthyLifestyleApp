//
//  AddTaskViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 30/05/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var tasksCategories: [String] = []
    
    @IBOutlet weak var newTaskName: UITextField!
    @IBOutlet weak var newTaskcategory: UIPickerView!
    @IBOutlet weak var newTaskDate: UIDatePicker!
    
    var taskName: String = ""
    var taskCategory: String = ""
    var taskDate: Date!
    var ifUpdated: Bool = false
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasksCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tasksCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        taskCategory = tasksCategories[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskCategory = tasksCategories[0]
        newTaskName.placeholder = "new task"
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNeWTask(_ sender: UIButton) {
        if !(newTaskName.text!.isEmpty) {
            taskName = String(newTaskName.text!)
            taskDate = newTaskDate.date
            ifUpdated = true
        }
        performSegue(withIdentifier: "unwindToTaskView", sender: self)
    }
    
    @IBAction func cancellNewTask(_ sender: UIButton) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
