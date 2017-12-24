//
//  HealthSourceProvider.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public struct HealthSourceProvider {

    private let healthStore: HKHealthStore

    public init?() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return nil
        }
        healthStore = HKHealthStore()
    }

    public func sources(sampleType: HKSampleType, completion: @escaping (Set<HKSource>?, Error?) -> Void) {
        let query = HKSourceQuery(sampleType: sampleType, samplePredicate: nil) { (_, sources, error) in
            completion(sources, error)
        }
        healthStore.execute(query)
    }

    public func appleSources(sampleType: HKSampleType, completion: @escaping (Set<HKSource>?, Error?) -> Void) {
        sources(sampleType: sampleType) { (sources, error) in
            completion(sources?.filter({ $0.bundleIdentifier.hasPrefix("com.apple.health") }), error)
        }
    }
}
