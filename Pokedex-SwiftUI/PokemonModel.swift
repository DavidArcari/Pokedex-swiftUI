//
//  PokemonModel.swift
//  Pokedex-SwiftUI
//
//  Created by David Arcari on 29/01/22.
//

import SwiftUI

struct Pokemon: Identifiable, Decodable {
    let pokeID = UUID()
    
    let id: Int
    let name: String
    let imageURL: String
    let type: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "imageUrl"
        case type
        case description
    }
    
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
}

enum FetchError: Error {
    case badURL
    case badResponse
    case badData
}

class PokemonModel {
    func getPokemon() async throws -> [Pokemon] {
        guard let url = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json") else { throw FetchError.badURL }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badResponse }
        guard let data = data.removeNullsFrom(string: "null,") else { throw FetchError.badData }
        
        let maybePokeminData = try JSONDecoder().decode([Pokemon].self, from: data)
        return maybePokeminData
    }
}

extension Data {
    func removeNullsFrom(string: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parseDataString = dataAsString?.replacingOccurrences(of: string, with: "")
        guard let data = parseDataString?.data(using: .utf8) else { return nil }
        return data
    }
}
