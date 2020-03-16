//
//  ViewController.swift
//  Watch Experiments
//
//  Created by Jess Purvis on 03/10/2019.
//  Copyright © 2019 Jess Purvis. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController,  WCSessionDelegate{

    
    
    let backgroundImageView = UIImageView()
    var wcsession: WCSession! = nil
    
    @IBOutlet weak var sessionTimeSlider: UISlider!
    
    
    @IBOutlet weak var sessionTimeLabel: UILabel!
    
    

    @IBAction func SliderChanged(_ sender: Any) {
        sessionTimeLabel.text = (String(Int((sessionTimeSlider.value)) )) + " Seconds"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundImage()
        
        // Do any additional setup after loading the view.
        
        wcsession = WCSession.default
        wcsession.delegate = self
        wcsession.activate()
        
        //sessionTimeLabel.text = String(sessionTimeSlider.value)
    }
    
    
    @IBAction func Launchpressed(_ sender: Any) {
        var sessionTime = String(Int(sessionTimeSlider.value))
        
        
        
        wcsession.sendMessage(["timeLength" : sessionTime], replyHandler: nil) { (Error) in
        //TODO: Add a pop-up warning the user if watch is not connected!
            print(Error.localizedDescription)}
        
    }
    


    //Methods for view
    
    func setBackgroundImage(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = #imageLiteral(resourceName: "stones copy.jpeg")
        
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    
    
    
//Methods for Watchkit session
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    

    
    
}
