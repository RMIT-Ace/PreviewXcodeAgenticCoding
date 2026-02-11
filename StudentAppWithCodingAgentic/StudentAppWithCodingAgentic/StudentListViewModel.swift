//
//  StudentListViewModel.swift
//  StudentAppWithCodingAgentic
//
//  Created by Ace on 9/2/2026.
//


import Foundation
import SwiftData
import Combine

@MainActor
final class StudentListViewModel: ObservableObject {
    @Published private(set) var students: [Student] = []

    private var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        if let context = modelContext {
            self.reload(using: context)
        }
    }

    func setContext(_ context: ModelContext) {
        self.modelContext = context
        self.reload(using: context)
    }

    func reload() {
        guard let context = modelContext else { return }
        reload(using: context)
    }

    private func reload(using context: ModelContext) {
        let descriptor = FetchDescriptor<Student>(sortBy: [
            SortDescriptor(\.lastName, order: .forward),
            SortDescriptor(\.firstName, order: .forward)
        ])
        if let result = try? context.fetch(descriptor) {
            self.students = result
        }
    }

    func delete(at offsets: IndexSet) {
        guard let context = modelContext else { return }
        for index in offsets { context.delete(students[index]) }
        try? context.save()
        reload(using: context)
    }

    func add(firstName: String, lastName: String, gender: String, address: String) {
        guard let context = modelContext else { return }
        let student = Student(firstName: firstName, lastName: lastName, gender: gender, address: address)
        context.insert(student)
        try? context.save()
        reload(using: context)
    }
}