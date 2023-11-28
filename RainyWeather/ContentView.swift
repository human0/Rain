//
//  ContentView.swift
//  RainyWeather
//
//  Created by Emmanuel Balogun on 2023/11/26.
//
//
//import SwiftUI
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var locationManager = CLLocationManager()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Current Weather")) {
                    if let currentWeather = viewModel.currentWeather {
                        Label("Add Item", systemImage: "plus") // WeatherDetailView(weather: currentWeather)
                    } else {
                        Text("Loading...")
                    }
                }

                Section(header: Text("7-Day Forecast")) {
                    ForEach(viewModel.forecast) { forecastItem in
                        Label("Add Item", systemImage: "plus") // ForecastItemView(forecastItem: forecastItem)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Weather App")
            .refreshable() {
                Task {
                    await viewModel.refreshWeather()
                }
            }
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = viewModel
            locationManager.startUpdatingLocation()
            Task {
                await viewModel.refreshWeather()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
