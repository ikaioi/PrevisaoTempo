//
//  ServicosLocalizacao.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation

/* Classe de suporte para manipular serviços de localização */
class ServicosLocalizacao {
    
    
    
    class func mensagemGPSdesativado() -> SafeUIAlertController {
        
        let alert = SafeUIAlertController(title: "GPS desligado", message: "Para um melhor uso do App, ative o GPS.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) -> Void in
            
            if let url = URL(string:UIApplication.openSettingsURLString)
            {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    
    
    class func mensagemAppDesautorizado() -> SafeUIAlertController {
        let alert = SafeUIAlertController(title: "Serviço de localização não autorizado", message: "Não foi possível encontrar a localização do aparelho. Precisamos que você permita o uso da localização para que o aplicativo funcione corretamente. Para usar a localização do aparelho, primeiro permita o serviço de localização.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    
    
    
    
    class func mensagemImpossivelUsarLocalizacao() -> SafeUIAlertController {
        let alert = SafeUIAlertController(title: "Serviço de localização não autorizado", message: "Impossível usar o serviço de localização. Verifique se o GPS do seu aparelho e se as configurações do aplicativo permitem o uso da localização.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    
    
    
    class func mensagemLocalizacaoNaoEncontrada() -> SafeUIAlertController {
        let alert = SafeUIAlertController(title: "Localização não encontrada", message: "Não foi possível encontrar a localização do aparelho.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    
    class func mensagemLocalizacaoNaoEncontrada_ConfirmarNovamente() -> SafeUIAlertController {
        let alert = SafeUIAlertController(title: "Localização não encontrada", message: "Não foi possível encontrar a localização do aparelho. Precisamos que você permita o uso da localização para que o aplicativo funcione corretamente.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    
    
    
    
    class func GPSEstaAutorizado(view:UIViewController) -> Bool {
        
        if !CLLocationManager.locationServicesEnabled() {
            //GPS DESLIGADO
            let alert = ServicosLocalizacao.mensagemGPSdesativado()
            view.present(alert, animated: true) { () -> Void in }
            return false
            
            
        } else {
            //GPS LIGADO
            let status = CLLocationManager.authorizationStatus()
            
            if(status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
                //GPS AUTORIZADO
                return true
                
                
            } else {
                //GPS APP NÃO AUTORIZADO
                let alert = ServicosLocalizacao.mensagemAppDesautorizado()
                view.present(alert, animated: true) { () -> Void in }
                return false
            }
        }
    }
    
    
    
}


fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
