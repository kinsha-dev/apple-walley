import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            CardsView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard")
                }

            ProfilesView()
                .tabItem {
                    Label("Profiles", systemImage: "person.2")
                }

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: Profile.self, inMemory: true)
    }
}