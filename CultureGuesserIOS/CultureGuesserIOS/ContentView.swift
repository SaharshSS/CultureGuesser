import SwiftUI

struct ContentView: View {
    @State private var rotate = false
    @State private var fastRotate = false
    @State private var startQuiz = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#4caf50")
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
                    Spacer().frame(height: 40) // Top spacing below settings icon

                    ZStack {
                        Image("Globe-01")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)

                        Image("People-01")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .rotationEffect(.degrees(rotate ? 360 : 0))
                            .animation(
                                Animation.linear(duration: fastRotate ? 0.5 : 5)
                                    .repeatForever(autoreverses: false),
                                value: rotate
                            )
                            .onAppear {
                                rotate = true
                            }
                    }

                    Text("CulturGuessr")
                        .font(.custom("Futura", size: 28))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Test your knowledge of cultures and landmarks around the world!")
                        .font(.custom("Futura", size: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Button(action: {
                        // Trigger fast rotation
                        fastRotate = true
                        
                        // After 1 second, navigate to quiz
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            startQuiz = true
                        }
                    }) {
                        Text("Start Game")
                            .font(.custom("Futura", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                    }

                    Spacer()
                }
                .padding()

                // Floating settings icon in top-right corner
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showSettings = true
                        }) {
                            Image("SettingsIcon-01")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $startQuiz) {
                IndexView()
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }
}

// Hex color extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
