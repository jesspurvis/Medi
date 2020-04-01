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

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    


    
    @IBOutlet weak var SecondsLabel: WKInterfaceLabel!
    @IBOutlet weak var HeartImage: WKInterfaceImage!
    @IBOutlet weak var HeartrateLabel: WKInterfaceLabel!
    @IBOutlet weak var BeginButton: WKInterfaceButton!
    
    var healthStore = HKHealthStore()
    var configuration = HKWorkoutConfiguration()
    var session: HKWorkoutSession!
    var builder: HKLiveWorkoutBuilder!
    

    var timer: Timer!
    
    var seconds = 60

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
        
        configuration = HKWorkoutConfiguration()
        configuration.activityType = .mindAndBody
        configuration.locationType = .indoor
    
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            
            builder = session.associatedWorkoutBuilder()
        } catch {
            print("weird issue")
            return
        }
        
        
        session.delegate = self
        builder.delegate = self
        
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
        workoutConfiguration: configuration)
        
        
    
        /// - Tag: StartSession
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (success, error) in
            self.runTimer()
        }

        //Config interface here
    }
    
    
        override func didDeactivate() {
            // This method is called when watch view controller is no longer visible
            super.didDeactivate()
        }
    
    
        override func willActivate(){
            super.willActivate()
        }
    
    
        
        
        
        //Update string showing heart rate
    private func updateHeartRateLabel(withStatistics statistics: HKStatistics?) {
        guard let statistics = statistics else {
            return
        }
        //HeartrateLabel.setText(heartRate)
        
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let value = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
        let roundedValue = Double( round( 1 * value! ) / 1 )
        HeartrateLabel.setText("\(roundedValue) BPM")
        
        averageBeats = Int(statistics.averageQuantity()!.doubleValue(for: heartRateUnit))
        
        
        
        
        
        //TODO: Change these values at some point
        switch roundedValue {
        case _ where roundedValue > 100.0:
            HeartrateLabel.setTextColor(.red)
        case _ where roundedValue > 70.0:
            HeartrateLabel.setTextColor(.yellow)
        default:
            HeartrateLabel.setTextColor(.green)
        }
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
            endWorkout()
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
    
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
        for type in collectedTypes {
        guard let quantityType = type as? HKQuantityType else {
            return // Nothing to do.
        }
            
            
        let statistics = workoutBuilder.statistics(for: quantityType)
        
                updateHeartRateLabel(withStatistics: statistics)
        
    }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        let lastEvent = workoutBuilder.workoutEvents.last
    }
    
    func endWorkout() {
        /// Update the timer based on the state we are in.
        /// - Tag: SaveWorkout
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            self.builder.finishWorkout { (workout, error) in
                // Dispatch to main, because we are updating the interface.
                DispatchQueue.main.async() {
                    self.dismiss()
                }
            }
        }
    }
    
    
    

    
    
}

