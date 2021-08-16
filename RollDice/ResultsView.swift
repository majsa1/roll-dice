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
    
    @State private var showingWarning = false
    @State private var dieToClear: Die?
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(dice, id: \.amountOfSides) { die in
                    Section(header: getHeader(for: die)) {
                        ForEach(die.formattedRolls, id: \.id) { roll in
                            HStack {
                                Text("Result: \(roll.result)")
                                Spacer()
                                Text("Amount of dice: \(roll.amountOfDice)")
                            }
                        }
                        .onDelete { offsets in
                            delete(at: offsets, from: die)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Results")
            .toolbar {
               EditButton()
            }
            .alert(isPresented: $showingWarning) {
                Alert(
                    title: Text("Are you sure you want to delete the results?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        clear()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    func getHeader(for die: Die) -> some View {
        HStack {
            Text("Die: \(die.amountOfSides)")
            Spacer()
            Button("Clear") {
                dieToClear = die
                showingWarning = true
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
    
    func clear() {
        moc.delete(dieToClear ?? Die())
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
