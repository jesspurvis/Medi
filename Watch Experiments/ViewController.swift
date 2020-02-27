//
//  ViewController.swift
//  Watch Experiments
//
//  Created by Jess Purvis on 03/10/2019.
//  Copyright © 2019 Jess Purvis. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController, ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func PermissionsTapped(_ sender: Any) {
        HealthKitManager.authorizeHealthKit()
    }
    
    //When Start button pressed begin a research task
    @IBAction func StartButtonPressed(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: BreatheTask, taskRun: nil)
        taskViewController.delegate = self
        taskViewController.outputDirectory = NSURL(fileURLWithPath:
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0],
                                                   isDirectory: true) as URL
        present(taskViewController, animated: true, completion: nil)
        HealthKitManager.startMockHeartData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
    }

    
}
