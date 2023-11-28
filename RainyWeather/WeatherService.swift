//
//  WeatherService.swift
//  RainyWeather
//
//  Created by Emmanuel Balogun on 2023/11/27.
//

import Foundation

class WeatherService {
    private let apiKey = "b5828c654e8571232bc855b93c60f5ab"
    private let baseUrl = "https://api.openweathermap.org/data/3.0/onecall"

    enum WeatherError: Error {
        case networkError
        case decodingError
    }

    func fetchData(latitude: Double, longitude: Double) async throws -> WeatherData {
        guard let url = URL(string: "\(baseUrl)?lat=\(latitude)&lon=\(longitude)&exclude=hourly,minutely&appid=\(apiKey)") else {
            throw WeatherError.networkError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            return weatherData
        } catch {
            print("Decoding error:", error)
            print("URL:", url)
            throw WeatherError.decodingError
        }
    }
}
