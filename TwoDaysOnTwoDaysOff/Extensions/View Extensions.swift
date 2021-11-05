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
        return
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
