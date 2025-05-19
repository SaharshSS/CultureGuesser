import Foundation
import CoreLocation

struct Location: Codable, Identifiable {
    let id = UUID()  // generated on init, excluded from decoding
    let name: String
    let latitude: Double
    let longitude: Double
    let questions: [Question]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case name, latitude, longitude, questions
    }
}

struct Question: Codable, Identifiable {
    let id = UUID()
    let question: String
    let answer: String

    private enum CodingKeys: String, CodingKey {
        case question, answer
    }
}

struct Player: Codable, Identifiable {
    let id: UUID
    var name: String
    var score: Int

    init(name: String, score: Int = 0) {
        self.id = UUID()
        self.name = name
        self.score = score
    }
}

struct GameState: Codable {
    var currentLocationIndex: Int
    var currentQuestionIndex: Int
    var players: [Player]
    var currentPlayerIndex: Int
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
