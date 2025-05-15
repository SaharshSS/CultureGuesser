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

            ZStack {
                Image("Globe-01")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 175, height: 175)

                Image("People-01")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(Animation.linear(duration: 4).repeatForever(autoreverses: false), value: rotate)
                    .onAppear {
                        rotate = true
                    }
            }
        }
    }
}

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
