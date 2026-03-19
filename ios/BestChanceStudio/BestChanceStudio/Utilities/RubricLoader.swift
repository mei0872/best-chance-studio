import Foundation

struct RubricLoader {
    static func load() -> RubricConfig {
        guard let url = Bundle.main.url(forResource: "rubric-config", withExtension: "json") else {
            fatalError("rubric-config.json not found in app bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to read rubric-config.json")
        }
        do {
            return try JSONDecoder().decode(RubricConfig.self, from: data)
        } catch {
            fatalError("Failed to decode rubric-config.json: \(error)")
        }
    }

    static func load(from data: Data) throws -> RubricConfig {
        try JSONDecoder().decode(RubricConfig.self, from: data)
    }
}
