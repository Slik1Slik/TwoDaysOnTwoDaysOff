//
//  Other Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 01.10.2021.
//

import UIKit
import Combine
import SwiftUI

//With a large title of a NavigationView, ScrollView may cause a glitching and unpredictable behaviour of the title.
//This extension fixes the issue.
extension ScrollView {
    
    func fixGlitching() -> some View {
        GeometryReader { proxy in
            ScrollView<ModifiedContent<Content, _PaddingLayout>>(axes, showsIndicators: showsIndicators) {
                content.padding(proxy.safeAreaInsets) as! ModifiedContent<Content, _PaddingLayout>
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//In some cases, appearing of the keyboard in a sheet pushes up view which presents the sheet. This extension fixes the issue.
extension View {
    func fixPushingUp() -> some View {
        GeometryReader { geometry in
            ZStack {
                self
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

extension View {
    var ifAvailable: Availability<Self> {
        Availability(content: self)
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
