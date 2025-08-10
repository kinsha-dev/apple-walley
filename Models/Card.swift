import Foundation
import SwiftData

@Model
final class Card {
    var id: UUID
    var name: String
    var category: String
    var data: String // This will hold the scanned NFC data
    var dateCreated: Date
    var imageData: Data?
    var profile: Profile?

    init(id: UUID = UUID(), name: String, category: String, data: String, imageData: Data? = nil, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.data = data
        self.imageData = imageData
        self.dateCreated = dateCreated
    }
}