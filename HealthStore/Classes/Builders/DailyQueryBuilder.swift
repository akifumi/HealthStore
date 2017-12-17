//
//  DailyQueryBuilder.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public struct DailyQueryBuilder: HealthStoreQueryBuildable {
    public let quantityType: HKQuantityType
    public var typesToRead: Set<HKObjectType>? {
        return [quantityType]
    }
    public let options: HKStatisticsOptions = .cumulativeSum
    public let anchorDate: Date
    public let intervalComponents: DateComponents = DateComponents(day: 1)
    public let predicates: [NSPredicate] = []

    public init(quantityType: HKQuantityType, calendar: Calendar = .current) {
        self.quantityType = quantityType
        self.anchorDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
}
