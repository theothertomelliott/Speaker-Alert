//
//  ReplacementSegue.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/24/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import UIKit

class ReplacementSegue: UIStoryboardSegue {
    
    override func perform() {
        let destinationController = self.destination
        
        if let navigationController = source.navigationController {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(destinationController, animated: false)
        }
        
    }
    
}
