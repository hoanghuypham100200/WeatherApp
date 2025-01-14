//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Huy on 12/1/25.
//
import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast : Forecast
}

struct Forecast: Codable {
    let forecastday: [Forecastday]
    
}
struct Forecastday : Codable {
    let hour : [Hour]
    let date : String
    let day : Day
}
struct Day : Codable {
    let condition: Condition
    let maxtemp_c: Double
    let mintemp_c:Double
}
struct Hour : Codable {
    let time : String
    let condition: Condition
    let temp_c: Double
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double
    let tempF: Double
    let condition: Condition
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
        case uv
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let code: Int
}

