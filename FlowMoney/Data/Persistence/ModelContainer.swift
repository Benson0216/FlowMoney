//
//  PersistenceModel.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/24.
//

import SwiftData

enum PersistenceController{
    static let shared: ModelContainer = {
        do {
            return try ModelContainer(
                for: Transaction.self
            )
        }
        catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()
}
