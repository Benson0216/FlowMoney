//
//  FlowMoneyApp.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/23.
//

import SwiftUI
import SwiftData

@main
struct FlowMoneyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(PersistenceController.shared)
    }
}
