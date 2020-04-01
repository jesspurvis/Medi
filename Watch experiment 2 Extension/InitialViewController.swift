//
//  InitialViewController.swift
//  Watch experiment 2 Extension
//
//  Created by Jess Purvis on 24/03/2020.
//  Copyright © 2020 Jess Purvis. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit
class InitialViewController : WKInterfaceController{
    
    
    @IBOutlet weak var timeSlider: WKInterfaceSlider!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    var sessionLength = 60
    
    let healthStore = HKHealthStore()
    
    
    
    override func didAppear() {
        super.didAppear()
        
    let typesToShare: Set = [
        HKQuantityType.workoutType()
    ]
    
    let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .heartRate)!
    ]
        
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
        if !success{ print("Issue with permissions, please try again")}
        }
        
    
        
        
        
    }
    
    
    
    
    @IBAction func SliderChanged(_ value: Float) {
        let roundedValue = Int(round(value))
        timeLabel.setText("\(TimeString(time:TimeInterval (roundedValue)))")
        sessionLength = roundedValue
    }
    
    
    
    @IBAction func StartSession() {
        pushController(withName: "watchscreen", context: sessionLength)
    }
    
    func TimeString(time:TimeInterval) -> String {
    
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    
    
    
}

