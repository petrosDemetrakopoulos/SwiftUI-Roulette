//
//  ContentView.swift
//  Roulette
//
//  Created by Petros Demetrakopoulos on 12/2/21.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    @State private var degreesAnimation = 0.0
    @State private var rand = 0.0
    @State private var newAngle = 0.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let halfSector = 360.0 / 37.0 / 2.0
    let sectors: [String] = ["32 RED","15 BLACK","19 RED","4 BLACK","21 RED","2 BLACK","25 RED","17 BLACK","34 RED","6 BLACK","27 RED","13 BLACK","36 RED","11 BLACK","30 RED","8 BLACK","23 RED","10 BLACK","5 RED","24 BLACK","16 RED","33 BLACK","1 RED","20 BLACK","14 RED","31 BLACK","9 RED","22 BLACK","18 RED","29 BLACK","7 RED","28 BLACK","12 RED","35 BLACK","3 RED","26 BLACK","ZERO"]
    var foreverAnimation: Animation {
            Animation.easeOut(duration: 3.0)
                .repeatCount(1, autoreverses: false)
        }
        
    func getAngle(angle: Double) -> Double {
        let deg = 360 - angle.truncatingRemainder(dividingBy: 360)
        return deg
    }

    func numberFromAngle(angle: Double) -> String {
        var i = 0
        var sector: String = ""
        
        repeat {
            let start: Double = halfSector * Double((i*2 + 1)) - halfSector
            let end: Double = halfSector * Double((i*2 + 3))
            
            if(angle >= start && angle <= end) {
                sector = sectors[i]
            }
            i+=1
        } while sector == "" && i < sectors.count
        return "Sector\n\(sector)"
    }
    var body: some View {
        VStack {
            Text(self.isAnimating ? "Spining\n..." : numberFromAngle(angle: newAngle)).multilineTextAlignment(.center)
            Image("Arrow").resizable().scaledToFit().frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Image("roulette").resizable().scaledToFit().rotationEffect(Angle(degrees: degreesAnimation)).frame(width: 245, height: 245, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .animation(foreverAnimation)
            .onAppear { self.isAnimating = false }
            Button("SPIN") {
                if(isAnimating) {
                    isAnimating = false
                } else {
                    isAnimating = true
                    rand = Double.random(in: 1...360)
                    degreesAnimation += 720.0 + rand
                    newAngle = getAngle(angle: degreesAnimation)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.9) {
                               isAnimating = false
                           }
                }
            }.padding(40)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
