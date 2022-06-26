//
//  func_withOptionalAnimation.swift
//  Flashzilla
//
//  Created by Eric Di Gioia on 6/18/22.
//
// This function behaves like withAnimation(), except checks for accessibility reduce motion bool and handles the animation accordingly

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}
