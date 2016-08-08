//
//  ConfigurationProtocol.swift
//  SpeakerAlert
//
//  Created by Thomas Elliott on 8/6/16.
//  Copyright © 2016 The Other Tom Elliott. All rights reserved.
//

import Foundation

protocol AppConfiguration: GeneralConfiguration, ModeConfiguration, AudioConfiguration {
}

protocol ModeConfiguration: Equatable, SpeechConfiguration, AlertConfiguration {
    
}

protocol GeneralConfiguration {
    var isAutoStartEnabled: Bool { get }
}

protocol SpeechConfiguration {
    var isDisplayTime: Bool { get }
    var speechDisplay: String { get }
    var isHideStatusEnabled: Bool { get }
    var isAlertOvertimeEnabled: Bool { get }
}

protocol AlertConfiguration {
    var isVibrationEnabled: Bool { get }
    var isAudioEnabled: Bool { get }
}

protocol AudioConfiguration {
    var isAudioEnabled: Bool { get }
    var audioFile: String { get }
}

// MARK: Equatable

func ==<T: SpeechConfiguration>(lhs: SpeechConfiguration, rhs: T) -> Bool {
    return  lhs.isDisplayTime == rhs.isDisplayTime &&
        lhs.speechDisplay == rhs.speechDisplay &&
        lhs.isHideStatusEnabled == rhs.isHideStatusEnabled &&
        lhs.isAlertOvertimeEnabled == rhs.isAlertOvertimeEnabled
}

func ==<T: AlertConfiguration>(lhs: AlertConfiguration, rhs: T) -> Bool {
    return  lhs.isAudioEnabled == rhs.isAudioEnabled &&
            lhs.isVibrationEnabled == rhs.isVibrationEnabled
}

func ==<T: ModeConfiguration, U: ModeConfiguration>(lhs: T, rhs: U) -> Bool {
    return  lhs as SpeechConfiguration == rhs &&
            lhs as AlertConfiguration == rhs
}
