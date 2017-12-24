//
//  ViewController.swift
//  HealthStore
//
//  Created by akifumi on 12/17/2017.
//  Copyright (c) 2017 akifumi. All rights reserved.
//

import UIKit
import HealthKit
import HealthStore

class ViewController: UIViewController {

    let healthStore = HealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let builder = DailyQueryBuilder(quantityType: type)
        healthStore?.observeSourceUpdates(from: Date(), builder: builder, handler: { [weak self] (_: [StepSource]?) in
            self?.reloadSteps()
        })
    }

    private func reloadSteps() {
        guard let healthStore = healthStore else { return }
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let builder = DailyQueryBuilder(quantityType: type)
        healthStore.requestSources(from: Date.startOfToday(), to: Date(), builder: builder) { (sources: [StepSource]?) in
            if let sources = sources {
                print("sources: \(sources)")
            } else {
                print("step sources are not found.")
            }
        }
    }
}
