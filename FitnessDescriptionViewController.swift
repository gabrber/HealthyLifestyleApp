//
//  FitnessDescriptionViewController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 30/05/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class FitnessDescriptionViewController: UIViewController {


    @IBOutlet weak var fitnessDetailsDescription: UITextView!
    @IBOutlet weak var fitnessNameTitle: UINavigationItem!
    @IBOutlet weak var fitnessDetailsNavigation: UINavigationBar!
    
    var fitnessName: String = ""
    var fitnessDescritpion: String = "xxx"

    override func viewDidLoad() {
        super.viewDidLoad()
       fitnessDetailsNavigation.setBackgroundImage(UIImage(), for: .default)
        fitnessDetailsNavigation.shadowImage = UIImage()
        fitnessDetailsNavigation.isTranslucent = true
        fitnessDetailsNavigation.backgroundColor = .clear
        
        self.fitnessNameTitle.title = fitnessName
        self.fitnessDetailsDescription.text = fitnessDescritpion
    }
    
    @IBAction func cancellDescription(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
