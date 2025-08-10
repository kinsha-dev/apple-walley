
import SwiftUI
import SwiftData
#if os(iOS)
import PhotosUI
#elseif os(macOS)
import AppKit
#endif

struct AddProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var profileName: String
    @State private var imageData: Data?
    var profile: Profile?

    init(profile: Profile? = nil) {
        self.profile = profile
        _profileName = State(initialValue: profile?.name ?? "")
        _imageData = State(initialValue: profile?.imageData)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Profile Name", text: $profileName)
                TextField("Image URL", text: .constant(""))
                Button("Save Profile") {
                    if let profile = profile {
                        profile.name = profileName
                        profile.imageData = imageData
                    } else {
                        let newProfile = Profile(name: profileName, imageData: imageData)
                        modelContext.insert(newProfile)
                    }
                    dismiss()
                }
                .disabled(profileName.isEmpty)
            }
            .navigationTitle(profile == nil ? "Add New Profile" : "Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
