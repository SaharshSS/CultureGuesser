//
//  ContentView.swift
//  CultureGuesserIOS
//
//  Created by Saharsh Shivshankar on 5/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var rotate = false

    var body: some View {
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
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Test your knowledge of cultures and landmarks around the world!")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: startQuiz) {
                    Text("Start Quiz")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 30)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                }
            }
            .padding()
        }
    }

    func startQuiz() {
        print("Start Quiz tapped!")
        // You can add navigation or functionality here
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
