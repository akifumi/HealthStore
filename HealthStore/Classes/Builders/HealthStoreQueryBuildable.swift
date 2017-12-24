//
//  HealthStoreQueryBuildable.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public protocol HealthStoreQueryBuildable {
    var quantityType: HKQuantityType { get }
    var typesToWrite: Set<HKSampleType>? { get }
    var typesToRead: Set<HKObjectType>? { get }
    var options: HKStatisticsOptions { get }
    var anchorDate: Date { get }
    var intervalComponents: DateComponents { get }
    var predicates: [NSPredicate] { get }
    func build() -> HKStatisticsCollectionQuery?
    func build(completion: @escaping (HKStatisticsCollectionQuery?) -> Void)
}

public extension HealthStoreQueryBuildable {

    var typesToWrite: Set<HKSampleType>? {
        return nil
    }

    var typesToRead: Set<HKObjectType>? {
        return nil
    }

    func build() -> HKStatisticsCollectionQuery? {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: options,
            anchorDate: anchorDate,
            intervalComponents: intervalComponents)
    }

    func build(completion: @escaping (HKStatisticsCollectionQuery?) -> Void) {
        completion(build())
    }
}
