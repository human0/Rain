//
//  WeatherData.swift
//  RainyWeather
//
//  Created by Emmanuel Balogun on 2023/11/27.
//

import Foundation

struct WeatherData: Decodable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let daily: [ForecastItem]
}

struct ForecastItem: Identifiable, Decodable {
    let id: UUID
    let weather: [WeatherDescription]
    //    let temp:
    init(id: UUID = UUID(), weather: [WeatherDescription]) {
        self.id = id
        self.weather = weather
    }
}

struct CurrentWeather: Decodable {
    let temp: Double
    let weather: [WeatherDescription]
}

struct WeatherDescription: Decodable {
    let main: String
    let description: String
    let icon: String
}

extension WeatherData {
    var temperature: Double {
        return current.temp
    }

    var weatherDescription: String {
        return current.weather.first?.description ?? ""
    }

    var weatherIcon: String {
        return current.weather.first?.icon ?? ""
    }
}
