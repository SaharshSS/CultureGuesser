import SwiftUI

struct CongratulationsView: View {
    @State private var navigateToContentView = false

    var body: some View {
        Color(hex: "#4caf50")
            .edgesIgnoringSafeArea(.all)
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                Color(hex: "#4caf50")
                    .edgesIgnoringSafeArea(.all)
                Text("🎉 Congratulations! 🎉")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Great job completing the quiz!")
                    .font(.title2)
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: {
                    navigateToContentView = true
                }) {
                    Text("Play Again")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true) // <-- Hide back button here
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView()
            }
        }
    }
}
