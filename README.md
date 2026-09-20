# FlowMoney

FlowMoney is an iOS personal finance app for tracking income and expenses.

This project is built as a practical software development project to practice iOS development, clean architecture, testing, and Git/GitHub workflows.

## Features

- Create, view, edit, and delete transactions
- Create, edit, and delete categories
- Assign categories to transactions
- Support different transaction types
- Support different payment methods
- Local data persistence with SwiftData

## Tech Stack

- Swift
- SwiftUI
- SwiftData
- Observation
- XCTest
- Git / GitHub

## Architecture

FlowMoney follows a layered architecture:

    SwiftUI View
        ↓
    ViewModel
        ↓
    Service
        ↓
    Repository
        ↓
    SwiftData

The architecture is designed to keep responsibilities separated and make the application easier to test and maintain.

## Testing

The project uses XCTest for unit testing.

Tests currently cover:

- Transaction model
- Category model
- Transaction repository
- Category repository
- Transaction service
- Category service
- Transaction ViewModel
- Category ViewModel
- Transaction editing
- Transaction deletion
- Category editing
- Category deletion

## Project Status

FlowMoney is an ongoing learning project.

The current implementation focuses on building a solid foundation for transaction and category management before expanding into additional features.

## Repository

GitHub: https://github.com/Benson0216/FlowMoney
