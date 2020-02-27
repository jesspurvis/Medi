//
//  HealthKitManager.swift
//  Watch Experiments
//
//  Created by Jess Purvis on 26/02/2020.
//  Copyright © 2020 Jess Purvis. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {

  static let healthKitStore = HKHealthStore()
  
    static var timer: Timer?

  static func authorizeHealthKit() {

    let healthKitTypes: Set = [
        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
    
    ]

    healthKitStore.requestAuthorization(toShare: healthKitTypes,
                                        read: healthKitTypes) { _, _ in }
  }
    
    
    static func saveMockHeartData() {

      // 1. Create a heart rate BPM Sample
        let heartRateType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"),
        doubleValue: Double(arc4random_uniform(80) + 100))
      let heartSample = HKQuantitySample(type: heartRateType,
                                         quantity: heartRateQuantity, start: NSDate() as Date, end: NSDate() as Date)

      // 2. Save the sample in the store
        healthKitStore.save(heartSample, withCompletion: { (success, error) -> Void in
        if let error = error {
          print("Error saving heart sample: \(error.localizedDescription)")
        }
      })
    }
    
    
    static func startMockHeartData() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
        target: self,
        selector: Selector(("saveMockHeartData")),
        userInfo: nil,
        repeats: true)
    }

    static func stopMockHeartData() {
      self.timer?.invalidate()
    }
    
    
    
}
