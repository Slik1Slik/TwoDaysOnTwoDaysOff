//
//  NotificationNameConstants.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 09.12.2021.
//

import Foundation

enum RealmNotificationsNames: String {
    case objectsDidUpdateNotificationKey
    case realmInstanceDidUpdateNotificationKey
    
    case objectWasDeletedNotificationKey
    case objectWasInsertedNotificationKey
    case objectWasModifiedNotificationKey
}
