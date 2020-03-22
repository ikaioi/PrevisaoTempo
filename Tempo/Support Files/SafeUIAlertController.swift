//
//  SafeUIAlertController.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import UIKit

//Evita travar apps, com alertas sendo exibidos, ao girar o aparelho
class SafeUIAlertController : UIAlertController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait,UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
}
