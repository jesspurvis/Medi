//
//  InterfaceController.swift
//  Watch experiment 2 Extension
//
//  Created by Jess Purvis on 27/02/2020.
//  Copyright © 2020 Jess Purvis. All rights reserved.
//

import SwiftUI


import Foundation
import HealthKit
import WatchKit

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var HeartImage: WKInterfaceImage!
    @IBOutlet weak var HeartrateLabel: WKInterfaceLabel!
    
    var healthStore : HKHealthStore?
    
    var lastHeartRate = 0.0
    let beatCountPerMinute = HKUnit(from: "count/min")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let sampleType: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .heartRate)!]
        healthStore = HKHealthStore()
        healthStore?.requestAuthorization(toShare: sampleType, read: sampleType, completion: { (success, error) in
            if success {
                self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            }
        })
        
        
        //self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)

        //Config interface here
    }

    
    
        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
            super.didDeactivate()
        }
        
        private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
            
            // Data is only needed from local device
            let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
            
            // Handle query updates
            let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
                query, samples, deletedObjects, queryAnchor, error in
                
                // Take a sample from this query
                guard let samples = samples as? [HKQuantitySample] else { return }
                
                self.process(samples, type: quantityTypeIdentifier)
            }
            
            // Create a query for heart rate on local device predicate
            let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
            
            query.updateHandler = updateHandler
            
            // Query start
            healthStore?.execute(query)
            
     
        }
        
        private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
           
            for sample in samples{
                if type == .heartRate {
                    lastHeartRate = sample.quantity.doubleValue(for: beatCountPerMinute)
                    
                
                }
                print("Function called")
                
                updateHeartRateLabel()
                //updateHeartRateSpeedLabel()
            }
     
        }
        //Update string showing heart rate
        private func updateHeartRateLabel() {
            let heartRate = String(Int(lastHeartRate))
            HeartrateLabel.setText(heartRate)
            print("Function called")
     
        }
        
        private func updateHeartRateSpeedLabel() {
            
        }

    @IBAction func BeginTapped() {
        

    }
}
