//
//  Blur.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 07.03.2022.
//

import SwiftUI
import UIKit

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .extraLight
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BackgroundBlurEffect: ViewModifier {
    var style: UIBlurEffect.Style
    func body(content: Content) -> some View {
        return content
            .background(Blur(style: style))
    }
}

extension View {
    func backgroundBlurEffect(style: UIBlurEffect.Style) -> some View {
        return self.modifier(BackgroundBlurEffect(style: style))
    }
}
