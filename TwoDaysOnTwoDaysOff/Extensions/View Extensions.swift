//
//  Other Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 01.10.2021.
//

import Foundation
import Combine
import SwiftUI

extension Binding {
    
    func publisher() -> BindingPublisher {
        return BindingPublisher(value: self.wrappedValue)
    }
    
    var initialValue: AnyPublisher<Value, Never> {
        self.publisher()
            .scan(self.wrappedValue) { value, _ in
                return value
            }
            .first()
            .eraseToAnyPublisher()
    }
    
    struct BindingPublisher: Publisher {
        
        typealias Output = Value
        
        typealias Failure = Never
        
        var value: Value
        var initialValue: Value
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Value == S.Input {
            let subscription = BindingSubscription(subscriber: subscriber, value: value)
            subscriber.receive(subscription: subscription)
        }
        
        init(value: Value) {
            self.value = value
            self.initialValue = value
        }
    }
    
    class BindingSubscription<S: Subscriber>: Subscription where S.Input == Value {
        
        var subscriber: S?
        var value: Value
        
        func cancel() {
            subscriber = nil
        }
        
        init(subscriber: S, value: Value) {
            self.subscriber = subscriber
            self.value = value
        }
        
        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else {
                subscriber?.receive(completion: .finished)
                return
            }
            let _ = subscriber?.receive(value)
        }
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

extension View {
    func overlay<Content: View>(content: @escaping () -> Content) -> some View {
        return self.overlay(content())
    }
}

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
