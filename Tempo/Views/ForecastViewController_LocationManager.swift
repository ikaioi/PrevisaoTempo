//
//  ForecastViewController_LocationManager.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


// MARK: - CLLocationManagerDelegate
extension ForecastViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        latitude = Double(location.coordinate.latitude)
        longitude = Double(location.coordinate.longitude)
        
        useLocationFirstTime(latitude: latitude,
                             longitude: longitude )
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse){
            //INICIAR BUSCA DE LOCALIDADE
            locationManager.startUpdatingLocation()
        } else if (status == .denied){
            if(ServicosLocalizacao.GPSEstaAutorizado(view:self)){
                guard self.locationManager.location != nil else{
                    let alert = ServicosLocalizacao.mensagemLocalizacaoNaoEncontrada()
                    self.present(alert, animated: true) { () -> Void in }
                    return
                }
            }
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        let alert = ServicosLocalizacao.mensagemAppDesautorizado()
        self.present(alert, animated: true) { () -> Void in }
        
    }
    
}
