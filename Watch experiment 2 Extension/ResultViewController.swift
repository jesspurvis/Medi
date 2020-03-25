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
class ResultViewController : WKInterfaceController{
    
       
    @IBOutlet weak var averageLabel: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let average = context as? Int{
           averageLabel.setText(String(average))
        } else {
            print("Passed context is not an Int: \(String(describing: context))")
        }
        
    }
    
    
}

