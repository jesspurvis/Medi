//
//  ResultViewController.swift
//  Watch experiment 2 Extension
//
//  Created by Jess Purvis on 25/03/2020.
//  Copyright © 2020 Jess Purvis. All rights reserved.
//

import Foundation
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
class ResultViewController : WKInterfaceController{
    

    @IBOutlet weak var averageLabel: WKInterfaceLabel!
    
    @IBOutlet weak var ratingLabel: WKInterfaceLabel!
    
    
    var isFemale = false
    var age = 0
    var rating = 0
    
    let healthStore = HKHealthStore()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let average = context as? Int{
           averageLabel.setText(String(average))
        } else {
            print("Passed context is not an Int: \(String(describing: context))")
        }
    }
    
       
    @IBAction func finsihButton() {
        pushController(withName: "initialView", context: nil)
    }
    
    
    
    
    
/**
    
    func calculateRating(){
        
        do {
            if try healthStore.biologicalSex().biologicalSex == HKBiologicalSex.female {isFemale = true}
            else if try healthStore.biologicalSex().biologicalSex == HKBiologicalSex.male {isFemale = false}
        }
        catch {
            print("SEX N/A")
        }
    
        
        do {
            let age = try healthStore.dateOfBirthComponents().year
        } catch {
            print("AGE N/A")
        }
        
        
        switch age {
        case _ where age > 25 :
            if (isFemale){
                
                
            }
            else{
                
            }
        default:
            
        }

        
       
    }
  **/

}
    



