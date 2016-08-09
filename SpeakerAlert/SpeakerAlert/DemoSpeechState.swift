//
//  DemoSpeechState.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 5/24/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation

class DemoSpeechState: SpeechState {
    
    override var running: SpeechRunning {
        get { return SpeechRunning.RUNNING }
        set {}
    }
    
    private var _phase: SpeechPhase
    override var phase: SpeechPhase {
        get { return _phase }
    }
    
    func nextPhase() {
        // Go to the next phase
        switch self._phase {
        case .BELOW_MINIMUM:
            self._phase = .GREEN
        case .GREEN:
            self._phase = .YELLOW
        case .YELLOW:
            self._phase = .RED
        case .RED:
            self._phase = .OVER_MAXIMUM
        case .OVER_MAXIMUM:
            self._phase = .OVER_MAXIMUM
        }
    }
    
    override func timeUntil(phase: SpeechPhase) -> NSTimeInterval {
        return 0
    }
    
    init() {
        _phase = SpeechPhase.BELOW_MINIMUM
        super.init(profile: SpeechProfile(green: 0, yellow: 0, red: 0, redBlink: 0))
    }
    
    override func toDictionary() -> [String : AnyObject] {
        return [:]
    }
}
