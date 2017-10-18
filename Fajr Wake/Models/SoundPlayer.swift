//
//  Sound.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/18/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import AVFoundation

struct SoundSetting {
    var ringtoneID: String
    var ringtoneExtension: String
    var isRepeated: Bool
}

class SoundPlayer {
    private var alarmSoundPlayer: AVAudioPlayer?
    private(set)var setting: SoundSetting
    
    init(setting: SoundSetting) {
        self.setting = setting
    }
    
    func playAlarmSound() {
        stopAlarmSound()
        let url = Bundle.main.url(forResource: setting.ringtoneID, withExtension: setting.ringtoneExtension)!
        do {
            alarmSoundPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = alarmSoundPlayer else { return }
            alarmSoundPlayer?.setVolume(1.0, fadeDuration: 3)
            if setting.isRepeated {
                player.numberOfLoops = -1
            }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func stopAlarmSound() {
        if alarmSoundPlayer != nil {
            alarmSoundPlayer?.stop()
            alarmSoundPlayer = nil
        }
    }
    
    func setSetting(setting: SoundSetting) {
        stopAlarmSound()
        self.setting = setting
    }
}
