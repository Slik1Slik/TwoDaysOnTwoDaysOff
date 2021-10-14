//
//  ExceptionIconViewModel.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import UIKit

class ExceptionIconViewModel: ObservableObject {
    var exceptionIcon: ExceptionIcon = ExceptionIcon()
    
    func icons(isWorking: Bool) -> [ExceptionIcon] {
        return ExceptionIconsDataStorageManager.shared.icons(isWorking: isWorking)
    }
}
