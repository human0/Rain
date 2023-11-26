//
//  RainyWeatherApp.swift
//  RainyWeather
//
//  Created by Emmanuel Balogun on 2023/11/26.
//

import SwiftUI

@main
struct RainyWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
