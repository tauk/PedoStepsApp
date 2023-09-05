//
//  ContentView.swift
//  PedoStepsApp
//
//  Created by Tauseef Kamal on 04/09/2023.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
   
    @State private var numberOfSteps: Int = 0
    @State private var distanceWalked: Double = 0
    @State private var pace : Double = 0
    
    private let pedometer = CMPedometer()

           var body: some View {
               VStack(spacing: 20) {
                   Text("Steps taken today: \(numberOfSteps)\nDistance Walked:\(distanceWalked) km\nAverage Pace: \(pace) secs/m")
                   Spacer()
               }
               
               //when view appears start updates and stop
               //app is in background etc
               .onAppear(perform: startPedometerUpdates)
               .onDisappear(perform: stopPedometerUpdates)
           }
           
           func startPedometerUpdates() {
               guard CMPedometer.isStepCountingAvailable() else {
                   print("Step counting is not available on this device.")
                   return
               }

               //get the steps from the start of the day
               
               let startOfDay = Calendar.current.startOfDay(for: Date())

               pedometer.startUpdates(from: startOfDay) { (data, error) in
                   if let steps = data?.numberOfSteps.intValue {
                       DispatchQueue.main.async {
                           self.numberOfSteps = steps
                       }
                   } else if let error = error {
                       print("Error fetching step data: \(error.localizedDescription)")
                   }
                   
                   if let distance = data?.distance?.doubleValue {
                       DispatchQueue.main.async {
                           let distanceKM = distance / 1000.00
                           self.distanceWalked = distanceKM
                       }
                   } else if let error = error {
                       print("Error fetching distance data: \(error.localizedDescription)")
                   }
                   
                   if let paceData = data?.averageActivePace?.doubleValue {
                       DispatchQueue.main.async {
                           self.pace = paceData
                       }
                   } else if let error = error {
                       print("Error fetching pace data: \(error.localizedDescription)")
                   }
               }
           }
           
           func stopPedometerUpdates() {
               pedometer.stopUpdates()
           }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
