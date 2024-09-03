//
//  Views+Extensions.swift
//  TrailAbout
//
//  Created by Misan on 9/2/24.
//

import SwiftUI

extension View {
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil )
    }
    
    func disableWithOpacity (_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func border (_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .stroke(color, lineWidth: width )
            )
    }
    
    func fillView (_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16.0, style: .continuous)
                    .fill(color)
            )
    }
    
    func hAlign (_ alignment: Alignment)-> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign (_ alignment: Alignment)-> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    
    
}
