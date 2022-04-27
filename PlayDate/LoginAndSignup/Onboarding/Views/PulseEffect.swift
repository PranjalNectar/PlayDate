//
//  PulseEffect.swift
//  PlayDate
//
//  Created by Pranjal Dudhe on 23/04/21.
//

import SwiftUI
import Combine

class PulsatingViewModel: ObservableObject {
    @Published var colorIndex = 1
}

struct PulseEffect: View {
    
    @ObservedObject var viewModel: PulsatingViewModel
    
    func colourToShow() -> Color {
        switch viewModel.colorIndex {
        case 0:
            return Color.white
        case 1:
            return Color.pink
        case 2:
            return Color.pink
        default:
            return Color.pink
        }
    }
    @State private var isActive: Bool = false
    @State var animate = false
    var body: some View {
        NavigationLink(destination: LoginView(), isActive: $isActive) {
            VStack {
                
                ZStack {
                    
                    Capsule().fill(Color.pink.opacity(0.75)
                    ).frame(width: 140, height: 60).scaleEffect(self.animate ? 1 : 0)
                    
                    Capsule().fill(Color.white.opacity(0.25)
                    ).frame(width: 160, height: 70).scaleEffect(self.animate ? 1 : 0)
                    
                    Button(action: {
                        self.isActive = true
                        print("Exit the onboarding")
                    }, label: {
                        Text("Get Started")
                            .fontWeight(.bold)
                        
                    })
                    .padding()
                    
                    .shadow(color: .pink, radius: 10, x: 0, y: 0)
                    .accentColor(Color.white)
                    .frame( height: 40)
                    .background(Color.pink)
                    .clipped()
                    .cornerRadius(20)
                    
                }
                
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() - 0.5) {
                        self.animate = true
                    }
                }
                .animation(animate ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .default)
                .onReceive(viewModel.$colorIndex) { _ in
                    self.animate = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.animate = true
                    }
                }
            }
        }
    }
}

struct TestPulseColorView: View {
    private var model = PulsatingViewModel()
    var body: some View {
        ZStack {
            Spacer()
            PulseEffect(viewModel: model)
            Spacer()
            
        }
    }
}

struct TestPulseColorView_Previews: PreviewProvider {
    static var previews: some View {
        TestPulseColorView()
        
    }
}
