//
//  ViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 12/03/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var fitnessLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = nil
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

