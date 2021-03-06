//
//  DemoViewController.swift
//  Demo
//
//  Created by Philip Kluz on 6/20/14.
//  Copyright (c) 2014 NSExceptional. All rights reserved.
//

import UIKit
import PKLocationManager
import CoreLocation

class DemoViewController: UIViewController {
                            
    @IBOutlet var locationMonitoringActiveLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    var secondMonitor = NSObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.adjustsFontSizeToFitWidth = true
        
        LocationManager.sharedManager.requiresLocationMonitoringWhenInUse = true
    }
    
    @IBAction func registerForLocationUpdates(sender: AnyObject) {
        var (success, error) = LocationManager.sharedManager.register(locationMonitor: self, desiredAccuracy: kCLLocationAccuracyBest, queue: dispatch_get_main_queue()) {
            [weak self] location in
            self!.locationLabel.text = location.description
        }
        
        LocationManager.sharedManager.register(locationMonitor: secondMonitor, desiredAccuracy: kCLLocationAccuracyBest, queue: dispatch_get_main_queue()) {
            location in
            println("Second Monitor received location: \(location)")
        }
        
        if success {
            locationMonitoringActiveLabel.text = "YES"
        } else {
            let alert = UIAlertController(title: "Registration Failed", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func deregisterFromLocationUpdates(sender: AnyObject) {
        LocationManager.sharedManager.deregister(self)
        LocationManager.sharedManager.deregister(secondMonitor)
        locationMonitoringActiveLabel.text = "NO"
        locationLabel.text = "--"
    }
}
