//
//  RestrictedSourceQueryBuilder.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public class RestrictedSourceQueryBuilder: HealthStoreQueryBuildable {
    public let quantityType: HKQuantityType
    public var typesToRead: Set<HKObjectType>? {
        return [quantityType]
    }
    public let options: HKStatisticsOptions = .cumulativeSum
    public let anchorDate: Date
    public let intervalComponents: DateComponents = DateComponents(day: 1)
    public var predicates: [NSPredicate] = []

    public init(quantityType: HKQuantityType, anchorDate: Date = Date.startOfToday()) {
        self.quantityType = quantityType
        self.anchorDate = anchorDate
    }

    public func build(completion: @escaping (HKStatisticsCollectionQuery?) -> Void) {
        guard let provider = HealthSourceProvider() else {
            completion(nil)
            return
        }
        provider.appleSources(sampleType: quantityType) { (sources, error) in
            if let error = error {
                print(error)
            }
            guard let sources = sources else {
                completion(nil)
                return
            }

            // update predicates
            let metadataPredicate = HKQuery.predicateForObjects(withMetadataKey: HKMetadataKeyWasUserEntered, operatorType: .notEqualTo, value: true)
            let sourcePredicate = HKQuery.predicateForObjects(from: sources)
            self.predicates = [metadataPredicate, sourcePredicate]

            // build query
            completion(self.build())
        }
    }
}
