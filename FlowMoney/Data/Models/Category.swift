//
//  Category.swift
//  FlowMoney
//
//  Created by Benson Lee on 2026/8/28.
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var icon: String
    var type: TransactionType
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        type: TransactionType,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.type = type
        self.createdAt = createdAt
    }
}
