//
//  ForecastViewModel.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation
import Alamofire

class ForecastViewModel {
    
    // MARK: - Properties

    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    var forecastNotAvailable: String? {
        didSet { self.showNotAvailableAlert?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    var setupLayout: Bool = false {
        didSet { self.didFinishConnection?() }
    }
    
    
    var showHoursForecast = false
    var showWeekForecast = false

    var dateToday = ""
    var temperatureNow = ""
    var descriptionWeatherNow = ""
    var sensationNow = ""
    var iconTempNowImg = ""
    

     
    
    
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var showNotAvailableAlert: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishConnection: (() -> ())?
    
    
    
    
    // MARK: - Constructor
    init() {  }
    
    
    
    
    // MARK: - Network call
    func connectForecast(lat: Double, long: Double){
        let latitude = lat
        let longitude = long
        let lang = "pt"
        let units = "auto"
        let key = APIKeys.darkSkyAPI
        
        
        self.isLoading = true
        AF.request("https://api.darksky.net/forecast/\(key)/\(latitude),\(longitude)?lang=\(lang)&units=\(units)")
            .validate()
            .responseJSON { response in
                
                self.isLoading = false
                
                if(response.error == nil){
                    //SE NAO HOUVE ERRO
                    do {
                        let forecast = try JSONDecoder().decode(Forecast.self, from: response.data!)
                        self.setupText(forecast)
                        
                    } catch {
                        self.error = error
                    }
                    
                    
                } else {
                    //SE HOUVE ERRO
                    if let error = response.error {
                        self.error = error
                        self.isLoading = false
                    }
                }
                
        }
    }
    
    
    
    
    
    // MARK: - UI Logic
    private func setupText(_ forecast: Forecast) {
        
        if(forecast.flags?.darksky_unavailable != nil){
            //SE NÃO HÁ PREVISÃO PARA O LOCAL INFORMADO
            self.forecastNotAvailable = forecast.flags?.darksky_unavailable
            
        } else {
            //CASO TENHA PREVISÃO DO TEMPO PARA O LOCAL
            
            //DEFININDO PREVISAO ATUAL
            if(forecast.currently != nil){
                dateToday = "\(createDateTime(timestamp: forecast.currently?.time ?? 0.0))"
                temperatureNow = "\(Int(forecast.currently?.temperature ?? 0.0))º"
                descriptionWeatherNow = forecast.currently?.summary ?? ""
                sensationNow = "Sensação térmica de \(Int(forecast.currently?.apparentTemperature ?? 0.0))º"
                iconTempNowImg = forecast.currently?.icon ?? "cloud"
            } else {
                dateToday = ""
                temperatureNow = ""
                descriptionWeatherNow = ""
                sensationNow = ""
                iconTempNowImg = "cloud"
            }
            
            
            //DEFININDO PREVISAO DAS PRÓXIMAS HORAS
            if(forecast.hourly != nil){
                showHoursForecast = true
            } else {
                showHoursForecast = false
            }
            
            
            //DEFININDO PREVISAO OS PRÓXIMOS DIAS
            if(forecast.daily != nil){
                showWeekForecast = true
            } else {
                showWeekForecast = false
            }
            
            
        
            setupLayout = true
        }
    }
    
    
    
    
    func createDateTime(timestamp: Double) -> String {
        var strDate = "undefined"
    
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
        dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "E, dd/MM  HH:mm" //Specify your format that you want
        strDate = dateFormatter.string(from: date)
    
        return strDate
    }
   
    
}
