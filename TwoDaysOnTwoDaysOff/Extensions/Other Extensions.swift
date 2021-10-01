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
