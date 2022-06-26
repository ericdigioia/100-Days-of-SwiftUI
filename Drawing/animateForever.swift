//
//  animateForever.swift
//  Drawing
//
//  Created by Eric Di Gioia on 5/11/22.
//

import Foundation
import SwiftUI

extension View {
    func animateForever(using animation: Animation = .linear(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)
        
        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}
