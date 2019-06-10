//
//  LaunchScreenController.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 02/06/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.performSegue(withIdentifier: "mainMenuSegue", sender: self)
        })
        
       //appName.textAlignment = .center

        // Do any additional setup after loading the view.
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
