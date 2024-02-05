//
//  PokemonModel.swift
//  PokeDex
//
//  Created by Swayam Rustagi on 05/02/24.
//

import Foundation
import SwiftUI


enum FetchError: Error{
    case badURL
    case badResponse
    case badData
}

class PokemonModel{
    func getPokemon() async throws -> [Pokemon]{
        guard let url = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json") else {
            throw FetchError.badURL
        }
        
    let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            throw FetchError.badResponse
        }
        guard let data = data.removeNullsFrom(string: "null,") else{ throw FetchError.badData}
        
        let decoder = JSONDecoder()
        let decodedPokemonData = try decoder.decode([Pokemon].self, from: data)
        return decodedPokemonData
    }
}

extension Data{ //to deal with null index in the api json
    func removeNullsFrom(string: String) -> Data? {
            guard let dataAsString = String(data: self, encoding: .utf8) else { return nil }
            let parsedDataString = dataAsString.replacingOccurrences(of: string, with: "")
            return parsedDataString.data(using: .utf8)
        }
}



struct Pokemon: Identifiable, Decodable{
    let pokeId = UUID()
    
    let id: Int
    let name: String
    let imageURL: String
    let type: String
    let description: String
    
    var typeColor: Color {
            switch type {
            case "fire":
                return Color(.systemRed)
            case "poison":
                return Color(.systemGreen)
            case "water":
                return Color(.systemTeal)
            case "electric":
                return Color(.systemYellow)
            case "psychic":
                return Color(.systemPurple)
            case "normal":
                return Color(.systemOrange)
            case "ground":
                return Color(.systemBrown)
            case "flying":
                return Color(.systemBlue)
            case "fairy":
                return Color(.systemPink)
            default:
                return Color(.systemIndigo)
            }
        }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case imageURL = "imageUrl"
        case type
        case  description
    }
}
