//
//  DetailsModalVC.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import UIKit

class DetailsModalVC: UIViewController {
    
    @IBOutlet weak var humidityLb: UILabel!
    @IBOutlet weak var pressureLb: UILabel!
    @IBOutlet weak var velocityLb: UILabel!
    @IBOutlet weak var coverSkyLb: UILabel!
    
    var dayWeather: Currently?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(dayWeather != nil){
            humidityLb.text = "\( Int(100 * (dayWeather?.humidity ?? 0.0)))%"
            pressureLb.text = "\(dayWeather?.pressure ?? 0.0) milibares"
            velocityLb.text = "\(dayWeather?.windSpeed ?? 0) km/h"
            coverSkyLb.text = "\( Int(100 * (dayWeather?.cloudCover ?? 0.0)))%"
        }
    }
    
    @IBAction func closeModal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeGesture(_ sender: UIPanGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
    
