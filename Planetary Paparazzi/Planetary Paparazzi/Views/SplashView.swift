//
//  SplashView.swift
//  Planetary Paparazzi
//
//  Created by Jaswitha Reddy G on 5/24/23.
//

import SwiftUI

struct SplashView: View {
    
    @State private var offset = CGSize.zero
    @State private var isActive = false
    
    var body: some View {
        
        if isActive {
            ContentView()
        } else {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image("splashscreen")
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                    // text with custom font and effect
                    Text("Planetary Paparazzi")
                        .font(.custom("Pokemon Solid", size: 70))
                        .foregroundColor(.yellow)
                        .multilineTextAlignment(.center)
                        .padding()
                        .overlay(
                            Text("Planetary Paparazzi")
                                .font(.custom("Pokemon Hollow", size: 70))
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.center)
                    )
                    Spacer()
                }
                Spacer()
            }
            .offset(offset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    self.offset = CGSize(width: 0, height: 20)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [#0F2027, .red]), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
            )
            
            // shows the splash screen for 10 seconds and also prints to console
            .onAppear{
                print("Splash Screen is loading for 10 seconds...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
