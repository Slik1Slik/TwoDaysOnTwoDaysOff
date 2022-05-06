//
//  AvailabilityModifier.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 24.04.2022.
//

import SwiftUI

struct Availability<Content> {
    let content: Content
}

extension Availability where Content: View {
    @ViewBuilder func tint(_ color: Color) -> some View {
        if #available(iOS 15, *) {
            content.tint(color)
        } else {
            content.accentColor(color)
        }
    }
}

extension Availability where Content: View {
    @ViewBuilder func overlay<OverlayContent: View>(_ overlayContent: @escaping () -> OverlayContent) -> some View {
        if #available(iOS 15, *) {
            content.overlay(content: overlayContent)
        } else {
            content.overlay(overlayContent())
        }
    }
}

extension Availability where Content: View {
    @ViewBuilder func overlay<OverlayContent: View>(alignment: Alignment, overlayContent: @escaping () -> OverlayContent) -> some View {
        if #available(iOS 15, *) {
            content.overlay(alignment: alignment, content: overlayContent)
        } else {
            content.overlay(overlayContent(), alignment: alignment)
        }
    }
}

extension Availability where Content: View {
    @ViewBuilder
    func alert(title: String,
               message: Text,
               isPresented: Binding<Bool>,
               primaryButtonTitle: Text,
               secondaryButtonTitle: Text,
               primaryButtonAction: @escaping () -> (),
               secondaryButtonAction: @escaping () -> ()) -> some View {
        if #available(iOS 15, *) {
            content.customAlert(title: title,
                                message: message,
                                isPresented: isPresented,
                                primaryButtonTitle: primaryButtonTitle,
                                secondaryButtonTitle: secondaryButtonTitle,
                                primaryButtonAction: primaryButtonAction,
                                secondaryButtonAction: secondaryButtonAction)
            
        } else {
            content.alert(isPresented: isPresented) {
                Alert(title: Text(title),
                      message: message,
                      primaryButton: .cancel(primaryButtonTitle, action: primaryButtonAction),
                      secondaryButton: .destructive(secondaryButtonTitle, action: secondaryButtonAction))
            }
        }
    }
}

extension View {
    @available(iOS 15.0, *)
    func customAlert(title: String,
                     message: Text,
                     isPresented: Binding<Bool>,
                     primaryButtonTitle: Text,
                     secondaryButtonTitle: Text,
                     primaryButtonAction: @escaping () -> (),
                     secondaryButtonAction: @escaping () -> ()) -> some View {
        return self
            .alert(title, isPresented: isPresented) {
                Button(role: .cancel, action: primaryButtonAction, label: { primaryButtonTitle })
                Button(role: .destructive, action: secondaryButtonAction, label: { secondaryButtonTitle })
            } message: {
                message
            }
        
    }
}

extension Availability where Content: View {
    @ViewBuilder
    func alert(title: String,
               message: Text,
               isPresented: Binding<Bool>,
               defaultButtonTitle: Text) -> some View {
        if #available(iOS 15, *) {
            content.simpleAlert(title: title,
                                message: message,
                                isPresented: isPresented,
                                defaultButtonTitle: defaultButtonTitle)
            
        } else {
            content.alert(isPresented: isPresented) {
                Alert(title: Text(title), message: message, dismissButton: .default(defaultButtonTitle))
            }
        }
    }
}

extension View {
    @available(iOS 15.0, *)
    func simpleAlert(title: String,
                     message: Text,
                     isPresented: Binding<Bool>,
                     defaultButtonTitle: Text) -> some View {
        return self
            .alert(title, isPresented: isPresented) {
                Button(role: .cancel, action: {}, label: { defaultButtonTitle })
            } message: {
                message
            }
        
    }
}
