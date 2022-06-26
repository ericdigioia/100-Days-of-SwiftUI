//
//  RollLogView.swift
//  DiceRoll
//
//  Created by Eric Di Gioia on 6/22/22.
//

import SwiftUI

struct RollLogView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var rollLog: [Int]
    
    var body: some View {
        NavigationView {
            List(rollLog, id: \.self) { roll in
                Text("\(roll)")
            }
            .toolbar { // TO DO: make clear log button appear red (destructive role not working)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Clear log", role: .destructive) {
                        rollLog = []
                        saveData()
                        print("Cleared roll log")
                    }
                    .accessibilityHint("Clear all previous rolls")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss", role: .cancel) {
                        dismiss()
                    }
                    .accessibilityHint("Return to main screen")
                }
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(rollLog) {
            try? data.write(to: FileManager.documentsDirectory.appendingPathComponent("RollLog"), options: [.atomicWrite, .completeFileProtection])
        }
    }
    
}

struct RollLogView_Previews: PreviewProvider {
    static var previews: some View {
        RollLogView(rollLog: .constant([1, 2, 3]))
            .preferredColorScheme(.dark)
    }
}
