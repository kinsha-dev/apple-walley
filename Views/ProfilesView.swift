
import SwiftUI
import SwiftData

struct ProfilesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [Profile]
    @State private var showingAddProfileSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(profiles) { profile in
                    NavigationLink(destination: AddProfileView(profile: profile)) {
                        Text(profile.name)
                    }
                }
                .onDelete(perform: deleteProfiles)
                
            
            }
            .navigationTitle("Profiles")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        showingAddProfileSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingAddProfileSheet) {
                AddProfileView()
            }
        }
    }

    
private func deleteProfiles(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(profiles[index])
        }
    }
}

struct ProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilesView()
            .modelContainer(for: Profile.self, inMemory: true)
    }
}
