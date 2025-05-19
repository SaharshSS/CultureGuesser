import SwiftUI

struct SettingsView: View {
    @State private var isMultiplayer = false
    @State private var isSoundOn = true
    @StateObject private var soundPlayer = SoundPlayer()

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
                        Toggle(isOn: $isSoundOn) {
                            HStack {
                                Text("Sound")
                                Spacer()
                                Image(systemName: isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            }
                        }
                        .onChange(of: isSoundOn) { value in
                            if value {
                                soundPlayer.playBackgroundMusic()
                            } else {
                                soundPlayer.stopBackgroundMusic()
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
                soundPlayer.playBackgroundMusic()
            }
        }
    }
}
