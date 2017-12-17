//
//  HealthStore.swift
//  
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public class HealthStore {
    private let healthStore: HKHealthStore

    private var observingQueries: [HKQuery] = []

    public init?() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return nil
        }
        healthStore = HKHealthStore()
    }

    deinit {
        // Stop all queries to observe updates
        observingQueries.forEach({ healthStore.stop($0) })
    }

    // Requests permission to save and read the specified data type
    public func requestAuthorization(toWrite typesToWrite: Set<HKSampleType>? = nil, toRead typesToRead: Set<HKObjectType>? = nil, completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { (success, error) in
            completion(success)
        }
    }

    // Issue statistics collection query
    private func requestStatisticsCollectionQuery(builder: HealthStoreQueryBuildable, completion: @escaping (HKStatisticsCollectionQuery?) -> Void) {
        requestAuthorization(toWrite: builder.typesToWrite, toRead: builder.typesToRead) { (success) in
            guard success else {
                completion(nil)
                return
            }

            let query = builder.build()
            completion(query)
        }
    }

    public func requestSources<T: Source>(from startDate: Date? = nil, to endDate: Date, builder: HealthStoreQueryBuildable, completion: @escaping ([T]?) -> Void) {
        requestStatisticsCollectionQuery(builder: builder) { [weak self] (query) in

            guard let query = query else {
                completion(nil)
                return
            }

            query.initialResultsHandler = { [weak self] (query, result, error) in
                completion(self?.summarizeSources(of: result, from: startDate, to: endDate))
            }

            self?.healthStore.execute(query)
        }
    }

    public func observeSourceUpdates<T: Source>(from startDate: Date? = nil, builder: HealthStoreQueryBuildable, handler: @escaping ([T]?) -> Void) {
        requestStatisticsCollectionQuery(builder: builder) { [weak self] (query) in

            guard let query = query else {
                handler(nil)
                return
            }

            // initial
            query.initialResultsHandler = { (query, result, error) in
                handler(self?.summarizeSources(of: result, from: startDate))
            }

            // update
            query.statisticsUpdateHandler = { [weak self] (query, statistics, collection, error) in
                handler(self?.summarizeSources(of: collection, from: startDate))
            }
            self?.observingQueries.append(query)

            self?.healthStore.execute(query)
        }
    }

    private func summarizeSources<T: Source>(of collection: HKStatisticsCollection?, from startDate: Date? = nil, to endDate: Date = Date()) -> [T]? {
        guard let collection = collection else { return nil }

        if let startDate = startDate {
            // Get data from startDate to endDate
            var sources = [T]()
            collection.enumerateStatistics(from: startDate, to: endDate, with: { (statistics, _) in
                guard let source = T(statistic: statistics) else { return }
                sources.append(source)
            })
            return sources

        } else {
            // Get all data
            return collection.statistics().flatMap({ T(statistic: $0) })
        }
    }
}
