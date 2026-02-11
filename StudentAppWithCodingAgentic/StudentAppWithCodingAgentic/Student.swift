import Foundation
import SwiftData

@Model
final class Student {
    var firstName: String
    var lastName: String
    var gender: String
    var address: String

    init(firstName: String, lastName: String, gender: String, address: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.address = address
    }
}
