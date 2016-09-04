//
//  LoadingViewController.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 9/12/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, DataSeederDependency {

    var dataSeeder: DataSeeder

    // Initializers for the app, using property injection
    required init?(coder aDecoder: NSCoder) {
        dataSeeder = LoadingViewController._dataSeeder()
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        dataSeeder = LoadingViewController._dataSeeder()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Initializer for testing, using initializer injection
    init(dataSeeder: DataSeeder) {
        self.dataSeeder = dataSeeder
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Add seed data
        dataSeeder.seedAsRequired()

        self.performSegueWithIdentifier("showMain", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
