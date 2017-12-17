//
//  StepSource.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public struct StepSource: Source {
    public let value: Int
    public let startDate: Date
    public let endDate: Date

    public init?(statistic: HKStatistics) {
        guard let sumQuantity = statistic.sumQuantity() else { return nil }

        self.value = Int(sumQuantity.doubleValue(for: HKUnit.count()))
        self.startDate = statistic.startDate
        self.endDate = statistic.endDate
    }
}
