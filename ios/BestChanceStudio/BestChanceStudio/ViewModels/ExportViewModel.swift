import Foundation

struct ExportViewModel {

    // MARK: - JSON Export

    static func buildJSON(
        dogName: String,
        scores: [String: Int],
        totalScore: Int,
        grade: String,
        gradeLabel: String,
        config: RubricConfig
    ) -> Data? {
        var dimensions: [[String: Any]] = []
        let priorityGapIds = config.dimensions
            .filter { (scores[$0.id] ?? 0) < $0.max }
            .sorted { (scores[$0.id] ?? 0) < (scores[$1.id] ?? 0) }
            .prefix(3)
            .map { $0.id }

        for dim in config.dimensions {
            let score = scores[dim.id] ?? 0
            let scoreKey = "score_\(score)"
            let actions = dim.coachingActions[scoreKey] ?? []
            let gap: String? = score < dim.max ? (dim.scores[String(score)] ?? nil) : nil

            dimensions.append([
                "id": dim.id,
                "label": dim.label,
                "score": score,
                "max": dim.max,
                "gap": gap as Any,
                "coaching_actions": actions
            ])
        }

        let result: [String: Any] = [
            "dog_name": dogName.isEmpty ? "Unknown" : dogName,
            "rubric_version": config.version,
            "scored_at": ISO8601DateFormatter().string(from: Date()),
            "total_score": totalScore,
            "max_score": config.maxScore,
            "grade": grade,
            "grade_label": gradeLabel,
            "dimensions": dimensions,
            "priority_gaps": priorityGapIds
        ]

        return try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys])
    }

    // MARK: - CSV Export

    static func buildCSV(
        dogName: String,
        scores: [String: Int],
        totalScore: Int,
        grade: String,
        config: RubricConfig
    ) -> String {
        var lines = ["Dimension,Score,Max,Gap"]
        for dim in config.dimensions {
            let score = scores[dim.id] ?? 0
            let gap = score < dim.max ? dim.scores[String(score)]?.replacingOccurrences(of: ",", with: ";") ?? "" : ""
            lines.append("\(dim.label),\(score),\(dim.max),\"\(gap)\"")
        }
        lines.append("")
        lines.append("Dog Name,\(dogName.isEmpty ? "Unknown" : dogName)")
        lines.append("Total Score,\(totalScore)/\(config.maxScore)")
        lines.append("Grade,\(grade)")
        lines.append("Scored At,\(ISO8601DateFormatter().string(from: Date()))")
        lines.append("Rubric Version,\(config.version)")
        return lines.joined(separator: "\n")
    }

    // MARK: - Temp File Helpers

    static func writeTempFile(name: String, extension ext: String, content: Data) -> URL? {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).\(ext)")
        do {
            try content.write(to: url)
            return url
        } catch {
            return nil
        }
    }

    static func writeTempFile(name: String, extension ext: String, content: String) -> URL? {
        guard let data = content.data(using: .utf8) else { return nil }
        return writeTempFile(name: name, extension: ext, content: data)
    }
}
