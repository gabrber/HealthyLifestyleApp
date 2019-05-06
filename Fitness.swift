//
//  Fitness.swift
//  HealthyLIfestyleApp
//
//  Created by macOS on 06/05/2019.
//  Copyright © 2019 macOS. All rights reserved.
//

import Foundation
import Firebase

protocol FitnessExercise {
    init?(dictionary:[String:Any])
}

struct Fitness {
    var name: String
    var image: String
    
    var dictionary:[String:Any] {
        return [
            "name": name,
            "image": image
        ]
    }
}

extension Fitness : FitnessExercise {
    init?(dictionary:[String : Any]) {
        guard let name = dictionary["name"] as? String,
            let image = dictionary["image"] as? String else {return nil}
        
        self.init(name: name, image: image)
    }
}
