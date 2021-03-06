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
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var timeSlider: WKInterfaceSlider!
    @IBOutlet weak var timeLabel: WKInterfaceLabel!
    
    var sessionLength = 60

    
    
    
    override func didAppear() {
        super.didAppear()
        
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKQuantityType.categoryType(forIdentifier: .mindfulSession)!
        ]
    
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.categoryType(forIdentifier: .mindfulSession)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if let error = error {
                print("Error requesting health kit authorization: \(error)")
            }
        }
    }
    
    // MARK: - Slider and Start
    
    @IBAction func SliderChanged(_ value: Float) {
        let roundedValue = Int(round(value))
        timeLabel.setText("\(TimeString(time:TimeInterval (roundedValue)))")
        sessionLength = roundedValue
    }
    
    
    
    
    @IBAction func StartSession() {
        let authorizationStatus = healthStore.authorizationStatus(for: HKSampleType.workoutType())
        if authorizationStatus == .sharingDenied{
            timeLabel.setText("Please give permissions,by changing this in the settings")
        }
        else{
            pushController(withName: "watchScreen", context: sessionLength)
        }
    }
    
    func TimeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    
    
    
}

