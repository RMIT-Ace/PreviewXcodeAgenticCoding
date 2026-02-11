import SwiftUI
import SwiftData

// MARK: - Views
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = StudentListViewModel()

    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.students, id: \.persistentModelID) { student in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(student.firstName) \(student.lastName)")
                            .font(.headline)
                        HStack(spacing: 8) {
                            Text(student.gender)
                                .foregroundStyle(.secondary)
                            Text("•")
                                .foregroundStyle(.tertiary)
                            Text(student.address)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: viewModel.delete)
            }
            .onAppear { viewModel.setContext(modelContext) }
            .navigationTitle("Students")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Label("Add Student", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) { EditButton() }
            }
            .sheet(isPresented: $showingAdd) {
                AddStudentView(viewModel: viewModel)
                    #if os(iOS)
                    .presentationDetents([.medium, .large])
                    #endif
            }
        }
    }
}

struct AddStudentView: View {
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: StudentListViewModel

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender = ""
    @State private var address = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                Section("Details") {
                    TextField("Gender", text: $gender)
                    TextField("Address", text: $address, axis: .vertical)
                        .lineLimit(1...3)
                }
            }
            .navigationTitle("Add Student")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func save() {
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespaces)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespaces)
        let trimmedGender = gender.trimmingCharacters(in: .whitespaces)
        let trimmedAddress = address.trimmingCharacters(in: .whitespaces)
        viewModel.add(firstName: trimmedFirst, lastName: trimmedLast, gender: trimmedGender, address: trimmedAddress)
        dismiss()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Student.self, inMemory: true)
}
