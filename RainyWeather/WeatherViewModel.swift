//
//  RainyWeatherViewModel.swift
//  RainyWeather
//
//  Created by Emmanuel Balogun on 2023/11/27.
//
import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeather: CurrentWeather?
    @Published var forecast: [ForecastItem] = []
    @Published var isRefreshing = false
    private var location: CLLocation?

    private let weatherService = WeatherService()

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            print("Location access denied")
        }
    }

    func refreshWeather() async {
        self.isRefreshing = true
        
        guard let location = location else {
                self.isRefreshing = false
            return
        }
        
        do {
            let weatherData = try await weatherService.fetchData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            DispatchQueue.main.async {
                self.currentWeather = weatherData.current
                self.forecast = weatherData.daily
                self.isRefreshing = false
            }
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isRefreshing = false
            }
        }

    }
}
