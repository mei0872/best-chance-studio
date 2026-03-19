import SwiftUI

struct ResultsView: View {
    let dogName: String
    let scores: [String: Int]
    let totalScore: Int
    let grade: String
    let gradeLabel: String
    @Environment(\.rubricConfig) private var config
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score header
                VStack(spacing: 8) {
                    if !dogName.isEmpty {
                        Text(dogName)
                            .font(.title2.bold())
                            .foregroundStyle(Color.bcsDark)
                    }

                    Text("\(totalScore)/\(config.maxScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.bcsDark)

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
                        .foregroundStyle(Color.bcsDark)

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
                        .foregroundStyle(Color.bcsDark)

                    HStack(spacing: 12) {
                        exportButton(label: "JSON", icon: "doc.text") {
                            exportJSON()
                        }
                        exportButton(label: "CSV", icon: "tablecells") {
                            exportCSV()
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: shareItems)
        }
    }

    private func exportButton(label: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.bcsOrange, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
        }
    }

    private func exportJSON() {
        guard let data = ExportViewModel.buildJSON(
            dogName: dogName,
            scores: scores,
            totalScore: totalScore,
            grade: grade,
            gradeLabel: gradeLabel,
            config: config
        ) else { return }

        let name = dogName.isEmpty ? "bcs-score" : dogName.lowercased().replacingOccurrences(of: " ", with: "-")
        if let url = ExportViewModel.writeTempFile(name: name, extension: "json", content: data) {
            shareItems = [url]
            showShareSheet = true
        }
    }

    private func exportCSV() {
        let csv = ExportViewModel.buildCSV(
            dogName: dogName,
            scores: scores,
            totalScore: totalScore,
            grade: grade,
            config: config
        )
        let name = dogName.isEmpty ? "bcs-score" : dogName.lowercased().replacingOccurrences(of: " ", with: "-")
        if let url = ExportViewModel.writeTempFile(name: name, extension: "csv", content: csv) {
            shareItems = [url]
            showShareSheet = true
        }
    }
}
