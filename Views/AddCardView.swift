
import SwiftUI
import SwiftData

struct AddCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Profile.name) var profiles: [Profile]
    
    @ObservedObject var nfcManager: NFCManager
    
    @State private var selectedProfile: Profile?
    @State private var cardName: String = ""
    @State private var cardCategory: String = ""
    @State private var scannedData: String = ""
    @State private var showingAddProfileSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Card Details") {
                    TextField("Card Name", text: $cardName)
                    TextField("Category (e.g., School ID)", text: $cardCategory)
                }
                
                Section("Assign to Profile") {
                    Picker("Profile", selection: $selectedProfile) {
                        Text("Select a Profile").tag(Profile?.none)
                        ForEach(profiles) { profile in
                            Text(profile.name).tag(profile as Profile?)
                        }
                    }
                    Button("Create New Profile") {
                        showingAddProfileSheet = true
                    }
                }
                
                #if os(iOS)
                Section("NFC Scan") {
                    Button("Scan Card") {
                        nfcManager.beginScanning()
                    }
                    Text("Scanned Data: \(scannedData)")
                }
#endif
                
                Button("Save Card") {
                    if let selectedProfile = selectedProfile, !cardName.isEmpty, !cardCategory.isEmpty, !scannedData.isEmpty {
                        let newCard = Card(name: cardName, category: cardCategory, data: scannedData)
                        selectedProfile.cards.append(newCard)
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch {
                            print("Failed to save card: \(error)")
                        }
                    }
                }
                .disabled(selectedProfile == nil || cardName.isEmpty || cardCategory.isEmpty || scannedData.isEmpty)
            }
            .navigationTitle("Add New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAddProfileSheet) {
                AddProfileView()
            }
        }
        .onReceive(nfcManager.$scannedData) { data in
            if let data = data {
                self.scannedData = data
            }
        }

    }
}
