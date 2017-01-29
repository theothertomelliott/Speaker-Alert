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
        get { return SpeechRunning.running }
        set {}
    }
    
    fileprivate var _phase: SpeechPhase
    override var phase: SpeechPhase {
        get { return _phase }
    }
    
    func nextPhase() {
        // Go to the next phase
        switch self._phase {
        case .below_MINIMUM:
            self._phase = .green
        case .green:
            self._phase = .yellow
        case .yellow:
            self._phase = .red
        case .red:
            self._phase = .over_MAXIMUM
        case .over_MAXIMUM:
            self._phase = .over_MAXIMUM
        }
    }
    
    override func timeUntil(_ phase: SpeechPhase) -> TimeInterval {
        return 0
    }
    
    init() {
        _phase = SpeechPhase.below_MINIMUM
        super.init(profile: SpeechProfile(green: 0, yellow: 0, red: 0, redBlink: 0))
    }
    
    override func toDictionary() -> [String : Any] {
        return [:]
    }
}
