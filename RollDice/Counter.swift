//
//  Counter.swift
//  RollDice
//
//  Created by Marjo Salo on 19/07/2021.
//

import SwiftUI

struct Counter: View {
    @Environment(\.managedObjectContext) private var moc
    
    let die: Int
    let dice: [[Int]] 
    let amountOfDice: Int

    @State private var indexes = [50, 50, 50]
    @State private var timesRemaining = [0, 0, 0]
    
    var indexRange: [[Int]] {
        var range = [[Int]]()
        for i in 0..<amountOfDice {
            let array = [indexes[i] - 3, indexes[i] - 2, indexes[i] - 1, indexes[i], indexes[i] + 1, indexes[i] + 2, indexes[i] + 3]
            range.append(array)
        }
        return range
    }
    
    @State private var results = [Int]()
    var formattedResults: Int {
        results.reduce(0, +)
    }
    
    @State private var rolling = false
    @State private var showingResult = false
    @State private var showingAlert = false
    
    @State private var timer: Timer?
    @State private var delay = 0.01
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        VStack(spacing: 40) {
            
            Text(rolling ? "Wait..." : "Roll")
                .fontWeight(.semibold)
                .padding()
                .frame(width: 100)
                .background(rolling ? Color.init(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)) : Color.pink)
                .colorButton()
                .foregroundColor(.white)
                .onLongPressGesture(minimumDuration: 3, pressing: { inProgress in
                    inProgress ? wind() : release()
                }) {
                }
                .allowsHitTesting(rolling == false)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Too early!"), message: Text("Press and hold to roll the dice"), dismissButton: .default(Text("OK")))
                }
                .accessibility(addTraits: .isButton)
                .accessibility(hint: Text("Press and hold to roll the dice"))
            
            HStack {
                ForEach(0..<amountOfDice, id: \.self) { number in
                    VStack {
                        ForEach(indexRange[number], id: \.self) { index in
                            Text("\(dice[number][index])")
                                .font(.title)
                        }
                    }
                    .frame(width: 85, height: 85, alignment: .center)
                    .colorButton()
                    .alert(isPresented: $showingResult) {
                        Alert(title: Text("You rolled \(formattedResults)"), dismissButton: .default(Text("Roll again")))
                    }
                    .accessibility(hidden: true)
                }
            }
        }
    }
    
    func wind() {
        results = []
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            withAnimation {
                for i in 0..<amountOfDice {
                    indexes[i] += 1
                    timesRemaining[i] += 1
                }
            }
        }
    }
    
    func release() {
        timer?.invalidate()
        for number in 0..<amountOfDice {
            roll(number: number)
        }
    }
    
    func roll(number: Int) {
        guard timesRemaining[number] > 2 else {
            feedback.prepare()
            showingAlert = true
            withAnimation {
                indexes[number] -= timesRemaining[number]
            }
            timesRemaining[number] = 0
            feedback.notificationOccurred(.error)
            return
        }
        
        rolling = true
        let num = timesRemaining[number] < 6 ? 0 : -3
        timesRemaining[number] += Int.random(in: num...3)
    
        for i in 0..<timesRemaining[number] {
            delay += 0.01
            DispatchQueue.main.asyncAfter(deadline: .now() + (delay * Double(i))) {
                timesRemaining[number] -= 1
                withAnimation {
                    indexes[number] -= 1
                }
                if timesRemaining[number] == 0 {
                    let die = dice[number]
                    let index = indexes[number]
                    results.append(die[index])
                    feedback.prepare()
                
                    if results.count == amountOfDice {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            save(result: formattedResults)
                            showingResult = true
                            rolling = false
                            self.feedback.notificationOccurred(.success)
                            delay = 0.01
                        }
                    }
                }
            }
        }
    }
    
    func save(result: Int) {
        let die = Die(context: moc)
        let amountOfSides = Int16(self.die)
        die.amountOfSides = amountOfSides

        let roll = Roll(context: moc)
        let amountOfDice = Int16(self.amountOfDice)
        let id = UUID()
        let result = Int16(result)
        let time = Date()
        roll.amountOfDice = amountOfDice
        roll.id = id
        roll.result = result
        roll.time = time
        
        die.addToRolls(roll)
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct Counter_Previews: PreviewProvider {
    static var previews: some View {
        let fourSided: [Int] = (0..<100).map { _ in Int.random(in: 1...6)}
        
        Counter(die: 4, dice: [fourSided, fourSided], amountOfDice: 2)
    }
}
