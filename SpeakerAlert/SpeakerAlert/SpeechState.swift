//
//  SpeechState.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 7/28/15.
//  Copyright © 2015 The Other Tom Elliott. All rights reserved.
//

import Foundation

enum SpeechState {
    case BELOW_MINIMUM
    case GREEN
    case YELLOW
    case RED
    case OVER_MAXIMUM // Speaker has gone significantly over time
}