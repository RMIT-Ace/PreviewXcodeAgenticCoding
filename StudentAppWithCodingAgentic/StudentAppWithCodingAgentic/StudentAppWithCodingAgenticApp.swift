//
//  StudentAppWithCodingAgenticApp.swift
//  StudentAppWithCodingAgentic
//
//  Created by Ace on 9/2/2026.
//

import SwiftUI
import SwiftData

@main
struct StudentAppWithCodingAgenticApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Student.self)
    }
}
