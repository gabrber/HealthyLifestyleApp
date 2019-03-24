//
//  ViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 12/03/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var fitnessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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

