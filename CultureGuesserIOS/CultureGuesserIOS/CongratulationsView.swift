import SwiftUI

struct CongratulationsView: View {
    var playerScores: [Player]

    var body: some View {
        VStack {
            Text("🎉 Game Over! 🎉")
                .font(.largeTitle)
                .padding()

            ForEach(playerScores, id: \.name) { player in
                Text("\(player.name): \(player.score) points")
                    .font(.title2)
                    .padding()
            }
        }
    }
}
