import SwiftUI
import AVFoundation

struct SettingsView: View {
    @State private var isMultiplayer = false
    @State private var isSoundOn = true
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            Color(hex: "#4caf50")
                .edgesIgnoringSafeArea(.all)

            VStack {
                List {
                    Section {
                        Toggle(isOn: $isMultiplayer) {
                            HStack {
                                Text("Player Mode")
                                Spacer()
                                Image(isMultiplayer ? "MultiPlayerIcon-01" : "SinglePlayerIcon-01")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .white))
                    }

                    Section {
                        Toggle(isOn: Binding(
                            get: { isSoundOn },
                            set: { newValue in
                                isSoundOn = newValue
                                toggleSound()
                            })
                        ) {
                            HStack {
                                Text("Sound")
                                Spacer()
                                Image(systemName: isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .white))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(hex: "#4caf50"))
            }
        }
        .onAppear {
            if isSoundOn {
                toggleSound()
            }
        }
    }

    func toggleSound() {
        if isSoundOn {
            if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
                let url = URL(fileURLWithPath: path)
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.numberOfLoops = -1
                    audioPlayer?.play()
                } catch {
                    print("Error loading music: \(error.localizedDescription)")
                }
            }
        } else {
            audioPlayer?.stop()
        }
    }
}
