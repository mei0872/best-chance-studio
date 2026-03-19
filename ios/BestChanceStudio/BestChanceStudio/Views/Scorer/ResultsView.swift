import SwiftUI

struct ResultsView: View {
    let dogName: String
    let scores: [String: Int]
    let totalScore: Int
    let grade: String
    let gradeLabel: String
    @Environment(\.rubricConfig) private var config
    @State private var jsonFileURL: URL?
    @State private var csvFileURL: URL?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score header
                VStack(spacing: 8) {
                    if !dogName.isEmpty {
                        Text(dogName)
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                    }

                    Text("\(totalScore)/\(config.maxScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    GradeBadgeView(grade: grade, size: .large)

                    Text(gradeLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)

                // Score bars
                VStack(alignment: .leading, spacing: 12) {
                    Text("Score Breakdown")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)

                    ForEach(config.dimensions) { dim in
                        ScoreBarView(
                            label: dim.label,
                            score: scores[dim.id] ?? 0,
                            maxScore: dim.max
                        )
                    }
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                // Gaps
                let gaps = config.dimensions
                    .filter { (scores[$0.id] ?? 0) < $0.max }
                    .sorted { (scores[$0.id] ?? 0) < (scores[$1.id] ?? 0) }
                    .prefix(3)
                    .map { $0 }

                GapsListView(gaps: gaps, scores: scores)
                    .padding()
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))

                // Export buttons
                VStack(spacing: 12) {
                    Text("Export")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)

                    HStack(spacing: 12) {
                        if let url = jsonFileURL {
                            ShareLink(item: url) {
                                Label("JSON", systemImage: "doc.text")
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.bcsOrange, in: RoundedRectangle(cornerRadius: 10))
                                    .foregroundStyle(.white)
                            }
                        }

                        if let url = csvFileURL {
                            ShareLink(item: url) {
                                Label("CSV", systemImage: "tablecells")
                                    .font(.subheadline.bold())
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.bcsOrange, in: RoundedRectangle(cornerRadius: 10))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .onAppear {
            prepareExportFiles()
        }
    }

    private func prepareExportFiles() {
        let name = dogName.isEmpty ? "bcs-score" : dogName.lowercased().replacingOccurrences(of: " ", with: "-")

        if let data = ExportViewModel.buildJSON(
            dogName: dogName,
            scores: scores,
            totalScore: totalScore,
            grade: grade,
            gradeLabel: gradeLabel,
            config: config
        ) {
            jsonFileURL = ExportViewModel.writeTempFile(name: name, extension: "json", content: data)
        }

        let csv = ExportViewModel.buildCSV(
            dogName: dogName,
            scores: scores,
            totalScore: totalScore,
            grade: grade,
            config: config
        )
        csvFileURL = ExportViewModel.writeTempFile(name: name, extension: "csv", content: csv)
    }
}
