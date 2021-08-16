//
//  ContentView.swift
//  RollDice
//
//  Created by Marjo Salo on 12/07/2021.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        
        TabView {
            RollView()
                .tabItem {
                    Image(systemName: "die.face.3")
                    Text("Roll")
                }
            
            ResultsView()
                .tabItem {
                    Image(systemName: "scroll")
                    Text("Results")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
