//
//  RollView.swift
//  RollDice
//
//  Created by Marjo Salo on 12/07/2021.
//

import SwiftUI

struct RollView: View {
    
    @State private var dice = [4, 6, 8, 10, 20, 100]
    @State private var die = 6
    @State private var amountOfDice = 2
    
    var diceArray: [[Int]] {
        let amountArray = Array(repeating: die, count: amountOfDice)
        var numbers = [[Int]]()
        for i in amountArray {
            let array = (0..<100).map { _ in Int.random(in: 1...i) }
            numbers.append(array)
        }
        return numbers
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
            
                Text("Select amount of dice:")
                    .fontWeight(.semibold)
                
                
                HStack {
                    ForEach(1..<4) { number in
                        Button("\(number)") {
                            amountOfDice = number
                        }
                        .frame(width: 40, height: 40, alignment: .center)
                        .background(amountOfDice == number ? Color.init(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)) : Color.init(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
                        .colorButton()
                        .foregroundColor(.white)
                    }
                }
                
                Text("Select amount of sides:")
                    .fontWeight(.semibold)
    
                
                VStack(spacing: 10) {
                    ForEach(0..<2) { col in
                        HStack(spacing: 10) {
                            ForEach(0..<3) { row in
                                let index = col * 3 + row
                                Button("\(dice[index])") {
                                    die = dice[index]
                                }
                                .frame(width: 40, height: 40, alignment: .center)
                                .background(die == dice[index] ? Color.init(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)) : Color.init(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
                                .colorButton()
                                .foregroundColor(.white)
                            }
                        }
                    }
                }
            
                Counter(die: die, dice: diceArray, amountOfDice: amountOfDice)
            }
            .navigationBarTitle("Roll Dice")
        }
    }
}

struct RollView_Previews: PreviewProvider {
    static var previews: some View {
        RollView()
    }
}
