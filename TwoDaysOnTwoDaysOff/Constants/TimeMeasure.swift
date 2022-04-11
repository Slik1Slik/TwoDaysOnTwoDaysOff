//
//  TimeMeasure.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 26.03.2022.
//

import Foundation

struct OperationTimeMeasurer {
    static func timeMeasureRunningCode(title: String, operationBlock: () -> ()) -> CFAbsoluteTime {
        let start = CFAbsoluteTimeGetCurrent()
        operationBlock()
        let finish = CFAbsoluteTimeGetCurrent()
        let timeElapsed = finish - start
        return timeElapsed
    }
}
