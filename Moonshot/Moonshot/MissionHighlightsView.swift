//
//  MissionHighlightsView.swift
//  Moonshot
//
//  Created by Eric Di Gioia on 5/5/22.
//

import SwiftUI

struct MissionHighlightsView: View {
    let mission: Mission
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.lightBackground)
                .padding(.vertical)
            
            Text("Mission Highlights")
                .font(.title.bold())
                .padding(.bottom, 5)
            
            Text(mission.description)
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.lightBackground)
                .padding(.vertical)
        }
    }
}

struct MissionHighlightsView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static var previews: some View {
        MissionHighlightsView(mission: missions[1])
            .preferredColorScheme(.dark)
    }
}
