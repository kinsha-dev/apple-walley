import Foundation
import SwiftData

@Model
final class Profile {
    var id: UUID
    var name: String
    var imageData: Data?
    @Relationship(deleteRule: .cascade) var cards = [Card]()

    init(id: UUID = UUID(), name: String, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
}