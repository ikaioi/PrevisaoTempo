//
//  ReusableHourView.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import UIKit

class ReusableHourView: UIView {

    @IBOutlet weak var hourLb: UILabel!
    @IBOutlet weak var temperaturLb: UILabel!
    @IBOutlet weak var humidityLb: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
    
    let nibName = "ReusableHourView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    
    //MARK: - SET LAYOUT ITEMS
    func setContent(hour: String, temperature: String, humidity: String, icon: String){
        hourLb.text = hour
        temperaturLb.text = temperature
        humidityLb.text = humidity
        iconImg.image = UIImage(named: icon)
    }
    
}
