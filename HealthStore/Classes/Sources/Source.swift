//
//  Source.swift
//
//
//  Created by Akifumi on 2017/12/17.
//

import HealthKit

public protocol Source {
    init?(statistic: HKStatistics)
}
