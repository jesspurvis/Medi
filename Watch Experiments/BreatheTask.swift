//
//  BreatheTask.swift
//  Watch Experiments
//
//  Created by Jess Purvis on 26/02/2020.
//  Copyright © 2020 Jess Purvis. All rights reserved.
//

import Foundation
import ResearchKit

public var BreatheTask: ORKOrderedTask {
    return ORKOrderedTask.fitnessCheck(withIdentifier: "WalkTask",
    intendedUseDescription: nil,
    walkDuration: 15 as TimeInterval,
    restDuration: 15 as TimeInterval,
    options: [])
}

