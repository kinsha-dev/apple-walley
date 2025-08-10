
import SwiftUI
import SwiftData

struct CardsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [Profile]
    @State private var showingAddCardSheet = false
    @StateObject private var nfcManager = NFCManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(profiles) { profile in
                    Section(header: Text(profile.name)) {
                        ForEach(profile.cards) { card in
                            Text(card.name)
                        }
                    }
                }
            }
            .navigationTitle("My Cards")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add Card") {
                        showingAddCardSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingAddCardSheet) {
                AddCardView(nfcManager: nfcManager)
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var previews: some View {
        CardsView()
            .modelContainer(for: Profile.self, inMemory: true)
    }
}
