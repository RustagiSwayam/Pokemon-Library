import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    var pokemonModel = PokemonModel()
    @State private var pokemon = [Pokemon]()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List {
                    ForEach(pokemon.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }) { poke in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(poke.name.capitalized)
                                    .font(.title)
                                HStack {
                                    Text(poke.type.capitalized)
                                        .italic()
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(poke.typeColor)
                                        .frame(width: 10, height: 10)
                                }
                                Text(poke.description)
                                    .font(.caption)
                                    .lineLimit(2)
                            }

                            Spacer()

                            AsyncImage(url: URL(string: poke.imageURL), scale: 3) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } else if phase.error != nil {
                                    Image(systemName: "photo")
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 100, height: 100)
                        }
                    }
                }
            }
            .navigationTitle("PokéDex")
        }
        .task {
            do {
                try await updatePokemon()
            } catch {
                print("Unable to fetch: \(error)")
            }
        }
    }

    private func updatePokemon() async throws {
        pokemon = try await pokemonModel.getPokemon()
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 8)
        }
        .padding(.vertical, 8)
    }
}
