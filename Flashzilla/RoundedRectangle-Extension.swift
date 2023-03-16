//
//  RoundedRectangle-Extension.swift
//  Flashzilla
//
//  Created by Derya Antonelli on 16/03/2023.
//

import SwiftUI

extension RoundedRectangle {
    static func swipeColor(offset: CGSize) -> Color {
        if offset.width > 0 {
            return .green
        }
        else if offset.width < .zero {
            return .red
        }
        
        return Color.clear
    }
}
