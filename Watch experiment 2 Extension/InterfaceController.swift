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
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
    @IBOutlet weak var SecondsLabel: WKInterfaceLabel!
    
    @IBOutlet weak var HeartImage: WKInterfaceImage!
    @IBOutlet weak var HeartrateLabel: WKInterfaceLabel!
   
    
    @IBOutlet weak var BeginButton: WKInterfaceButton!
    
    var healthStore : HKHealthStore?
    
    var wcSession : WCSession!

    

    var timer: Timer!
    
    var seconds = 80
    
  
  
    var began =  false
    
    var beat = true
    
    var totalBeats = 0.0
    
    var averageBeats = 0
    
  
    
    
    
    var lastHeartRate = 0.0
    let beatCountPerMinute = HKUnit(from: "count/min")
    //test
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let sessionLength = context as? Int{
            seconds = sessionLength + 1 //The ++ is due to a bug of setting timer - 1
           SecondsLabel.setText(timeString(time: TimeInterval(seconds)))
        } else {
            print("Passed context is not an Int: \(String(describing: context))")
        }
        
        let sampleType: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .heartRate)!]
        healthStore = HKHealthStore()
        healthStore?.requestAuthorization(toShare: sampleType, read: sampleType, completion: { (success, error) in
            if success {
                self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            }
        })
        updatetimer()
        

        //Config interface here
    }
    
    
        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
            super.didDeactivate()
        }
    
    
        override func willActivate(){
            super.willActivate()
            wcSession = WCSession.default
            wcSession.delegate = self
            wcSession.activate()
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
                    //totalBeats += lastHeartRate
                }
                
                let completion: ((Bool, Error?) -> Void) = {
                    (success, error) -> Void in

                    if !success {
                        print("An error occured saving the Heart Rate sample \(sample). \(String(describing: error)).")
                        abort()
                    }
                }
                
                
                healthStore?.save(samples, withCompletion: completion)
                
                updateHeartRateLabel()
            
            }
             
            //if !(samples.isEmpty){ averageBeats = Int(totalBeats) / samples.count}
            print(samples.count)
     
        }
        //Update string showing heart rate
        private func updateHeartRateLabel() {
            let heartRate = String(Int(lastHeartRate))
            HeartrateLabel.setText(heartRate)
            //print("Function called")
            
     
        }
        

            
    //Timer countdown methods
    
    func runTimer(){
        //For every second that passes, call the update timer method
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatetimer), userInfo: nil, repeats: true)
    }
    
    func timeString(time:TimeInterval) -> String {
    
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
    @objc func updatetimer(){
        if seconds < 50 {
            
            //SecondsLabel.setText("Finish!")
            pushController(withName: "resultView", context: averageBeats)
            timer.invalidate()
            
            //Context is the data I might want to add
        }
        
        else{
        seconds -= 1
        SecondsLabel.setText(timeString(time: TimeInterval(seconds)))
            animateHeart()
        }
        
    }

    @IBAction func BeginTapped() {
        if began == true{
            
            BeginButton.setTitle("Start")
            //SessionTimer.start()
            timer.invalidate()
            
            began = false
        }
        else{
            BeginButton.setTitle("Stop")
            //SessionTimer.stop()
            began = true
            runTimer()
            
        }
        
    }
    
    func animateHeart() {
        if beat == true {
            self.animate(withDuration: 0.5) {
                self.HeartImage.setWidth(50)
                self.HeartImage.setHeight(80)
              }
            beat = false
        }
        
        else {
            self.animate(withDuration: 0.5) {
                    self.HeartImage.setWidth(60)
                    self.HeartImage.setHeight(90)
                }
              beat = true
        }
    }
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        let timer = message["timeLength"] as! String
        seconds = Int(timer)!
        updatetimer()
        
        
    }
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
}

