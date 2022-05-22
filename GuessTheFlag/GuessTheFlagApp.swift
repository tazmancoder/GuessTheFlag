//
//  GuessTheFlagApp.swift
//  GuessTheFlag
//
//  Created by Mark Perryman on 5/13/22.
//

import SwiftUI

@main
struct GuessTheFlagApp: App {
    @StateObject var jsonData = LoadJSONData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(jsonData)
                .onAppear {
                    // This suppresses constraint warnings
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
