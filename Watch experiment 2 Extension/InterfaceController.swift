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
    
    @IBOutlet weak var HeartrateLabel: WKInterfaceLabel!
    
    var healthStore : HKHealthStore?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        
        let sampleType: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .heartRate)!]
        healthStore = HKHealthStore()
        
        healthStore?.requestAuthorization(toShare: sampleType, read: sampleType, completion: { (success, error) in
            if success {
                self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            }
        })
        
        //Config interface here
    }

    
    
        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
            super.didDeactivate()
        }
        
        private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
            
            // 1
            let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
            
            // 2
            let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
                query, samples, deletedObjects, queryAnchor, error in
                
                // 3
                guard let samples = samples as? [HKQuantitySample] else { return }
                
                self.process(samples, type: quantityTypeIdentifier)
            }
            
            // 4
            let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
            
            query.updateHandler = updateHandler
            
            // 5
            healthStore?.execute(query)
     
        }
        
        private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
     
        }
        
        private func updateHeartRateLabel() {
     
        }
        
        private func updateHeartRateSpeedLabel() {
            
        }

}
