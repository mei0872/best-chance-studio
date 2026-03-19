import SwiftUI

struct SessionDetailView: View {
    let dog: Dog
    let session: ScoringSession
    @Environment(\.rubricConfig) private var config
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text(dog.name)
                        .font(.title2.bold())
                        .foregroundStyle(Color.bcsDark)

                    Text("\(session.totalScore)/\(session.maxScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.bcsDark)

                    GradeBadgeView(grade: session.grade, size: .large)

                    Text(session.gradeLabel)
                        .font(.subheadline)
                        .foregroundStyle(Color.bcsText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("Scored \(session.scoredAt, style: .date) at \(session.scoredAt, style: .time)")
                        .font(.caption)
                        .foregroundStyle(Color.bcsText.opacity(0.6))

                    Text("Rubric v\(session.rubricVersion)")
                        .font(.caption2)
                        .foregroundStyle(Color.bcsText.opacity(0.4))
                }
                .padding(.top)

                // Score bars
                VStack(alignment: .leading, spacing: 12) {
                    Text("Score Breakdown")
                        .font(.title3.bold())
                        .foregroundStyle(Color.bcsDark)

                    ForEach(config.dimensions) { dim in
                        let dimScore = session.dimensionScores.first { $0.dimensionId == dim.id }
                        ScoreBarView(
                            label: dim.label,
                            score: dimScore?.score ?? 0,
                            maxScore: dim.max
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                // Gaps
                let scores = Dictionary(
                    uniqueKeysWithValues: session.dimensionScores.map { ($0.dimensionId, $0.score) }
                )
                let gaps = config.dimensions
                    .filter { (scores[$0.id] ?? 0) < $0.max }
                    .sorted { (scores[$0.id] ?? 0) < (scores[$1.id] ?? 0) }
                    .prefix(3)
                    .map { $0 }

                GapsListView(gaps: gaps, scores: scores)
                    .padding()
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                // Export
                HStack(spacing: 12) {
                    Button {
                        exportJSON(scores: scores)
                    } label: {
                        Label("JSON", systemImage: "doc.text")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.bcsOrange, in: RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                    }

                    Button {
                        exportCSV(scores: scores)
                    } label: {
                        Label("CSV", systemImage: "tablecells")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.bcsOrange, in: RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(.white)
                    }
                }
                .padding()
            }
            .padding()
        }
        .background(Color.bcsCream)
        .navigationTitle(dog.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: shareItems)
        }
    }

    private func exportJSON(scores: [String: Int]) {
        guard let data = ExportViewModel.buildJSON(
            dogName: dog.name,
            scores: scores,
            totalScore: session.totalScore,
            grade: session.grade,
            gradeLabel: session.gradeLabel,
            config: config
        ) else { return }

        let name = dog.name.lowercased().replacingOccurrences(of: " ", with: "-")
        if let url = ExportViewModel.writeTempFile(name: name, extension: "json", content: data) {
            shareItems = [url]
            showShareSheet = true
        }
    }

    private func exportCSV(scores: [String: Int]) {
        let csv = ExportViewModel.buildCSV(
            dogName: dog.name,
            scores: scores,
            totalScore: session.totalScore,
            grade: session.grade,
            config: config
        )
        let name = dog.name.lowercased().replacingOccurrences(of: " ", with: "-")
        if let url = ExportViewModel.writeTempFile(name: name, extension: "csv", content: csv) {
            shareItems = [url]
            showShareSheet = true
        }
    }
}
