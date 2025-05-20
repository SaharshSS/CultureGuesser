import Foundation
import AVFoundation

class SoundPlayer: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let path = Bundle.main.path(forResource: "music", ofType: "mp3") else {
            print("❌ music.mp3 not found in bundle")
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Loop forever
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("✅ Playing music.mp3")
        } catch {
            print("❌ Error initializing AVAudioPlayer: \(error.localizedDescription)")
        }
    }

    func stopBackgroundMusic() {
        audioPlayer?.stop()
        print("🛑 Music stopped")
    }
}
