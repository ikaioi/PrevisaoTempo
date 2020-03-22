//
//  Forecast.swift
//  Tempo
//
//  Created by Kaio Dantas on 22/03/20.
//  Copyright © 2020 Kaio Dantas. All rights reserved.
//

import Foundation

struct Forecast: Decodable{
    
    let latitude: Double
    let longitude: Double
    let timezone: String
    let offset: Int?
    
    let currently: Currently?
    let hourly: Hourly?
    let daily: Daily?
    let flags: Flag?
}


struct Currently: Decodable{
    
    let time: Double?
    let summary: String?
    let icon: String?
    
    let temperature: Double?
    let apparentTemperature: Double?
    
    let temperatureMin: Double?
    let temperatureMinTime: Int?
    let temperatureMax: Double?
    let temperatureMaxTime: Double?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMax: Double?
    
    let sunriseTime: Int?
    let sunsetTime: Int?
    let humidity: Double?
    let pressure: Double?
    let visibility: Double?
    let windSpeed: Double?
    let precipIntensity: Double?
    let precipProbability: Double?
    let cloudCover: Double?
    
}


struct Hourly: Decodable{
    
    let summary: String?
    let icon: String?
    let data: [Currently]
    
}


struct Daily: Decodable{
    
    let summary: String?
    let icon: String?
    let data: [Currently]
    
}


struct Flag: Decodable{
    
    let sources: [String]?
    let units: String?
    let darksky_unavailable: String?
    let nearest_station: Double?
    
    enum CodingKeys : String, CodingKey {
        case sources
        case units
        case darksky_unavailable = "darksky-unavailable"
        case nearest_station = "nearest-station"
    }
}


