//
//  RealmObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 09.12.2021.
//

import Foundation
import RealmSwift
import Combine

class RealmObserver<Element: Object>: ObservableObject {
    
    var notificationToken = NotificationToken()
    
    private var object: Element.Type
    
    var onRealmDidInitialize = { } {
        didSet {
            activateToken()
        }
    }
    
    var onObjectsHaveBeenChanged: () -> () = { }
    
    var onObjectsHaveBeenDeleted: ([Int]) -> () = { _ in } {
        didSet {
            activateToken()
        }
    }
    var onObjectHasBeenInserted: (Element) -> () = { _ in }{
        didSet {
            activateToken()
        }
    }
    var onObjectHasBeenModified: (Element) -> () = { _ in }{
        didSet {
            activateToken()
        }
    }
    
    var error: Error?
    
    init(for object: Element.Type) {
        self.object = object
        activateToken()
    }
    
    deinit {
        notificationToken.invalidate()
    }
    
    private func activateToken() {
        notificationToken = realm.objects(object).observe({ [unowned self] event in
            switch event {
            case .initial(_):
                onRealmDidInitialize()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                if !deletions.isEmpty {
                    onObjectsHaveBeenDeleted(deletions)
                }
                if !insertions.isEmpty {
                    onObjectHasBeenInserted(realm.objects(object).last!)
                }
                if !modifications.isEmpty {
                    onObjectHasBeenModified(realm.objects(object)[modifications.last!])
                }
                onObjectsHaveBeenChanged()
            case .error(_):
                break
            }
        })
    }
}
