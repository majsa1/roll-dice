//
//  ResultsView.swift
//  RollDice
//
//  Created by Marjo Salo on 12/07/2021.
//

import SwiftUI

struct ResultsView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: Die.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Die.amountOfSides, ascending: true)
    ]) var dice: FetchedResults<Die>
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(dice, id: \.self) { die in
                    Section(header: Text("Die: \(die.amountOfSides)")) {
                        ForEach(die.formattedRolls, id: \.id) { roll in
                            HStack {
                                Text("Result: \(roll.result)")
                                Spacer()
                                Text("Amount of dice: \(roll.amountOfDice)")
                            }
                        }
                        .onDelete(perform: { offsets in
                            delete(at: offsets, from: die)
                        })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Results")
            .toolbar {
               EditButton()
            }
        }
    }
    
    func delete(at offsets: IndexSet, from die: Die) { 
        for offset in offsets {
            let roll = die.formattedRolls[offset]
            die.removeFromRolls(roll)
            moc.delete(roll)
            
            if die.formattedRolls.isEmpty {
                moc.delete(die)
            }
        }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
