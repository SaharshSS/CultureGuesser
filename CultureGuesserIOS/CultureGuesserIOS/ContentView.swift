import SwiftUI

struct ContentView: View {
    @State private var rotate = false
    @State private var startQuiz = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#4caf50")
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 30) {
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
                            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: rotate)
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
                        startQuiz = true
                    }) {
                        Text("Start Quiz")
                            .font(.custom("Futura", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true) // Hide back button here
            .navigationDestination(isPresented: $startQuiz) {
                IndexView()
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
