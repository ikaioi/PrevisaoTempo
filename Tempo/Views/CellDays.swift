//
//  CellDays.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import UIKit

class CellDays: UICollectionViewCell {
    
    @IBOutlet weak var dayLb: UILabel!
    @IBOutlet weak var maxTemperatureLb: UILabel!
    @IBOutlet weak var minTemperatureLb: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var viewDifferenceTemperatures: UIView!
    
    
    func setContent(day: String, maxTemperature: String, minTemperature: String, heightDifferenceTemperatures: Int, icon: String){
        
        dayLb.text = day
        maxTemperatureLb.text = maxTemperature
        minTemperatureLb.text = minTemperature
        iconImg.image = UIImage(named: icon)
        viewDifferenceTemperatures.heightAnchor.constraint(equalToConstant: CGFloat(heightDifferenceTemperatures)).isActive = true
    }

}
