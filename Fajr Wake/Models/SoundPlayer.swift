//
//  Sound.swift
//  Fajr Wake
//
//  Created by Ali Mir on 10/18/17.
//  Copyright © 2017 com.AliMir. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - struct SoundSetting

struct SoundSetting {
    var ringtoneID: String
    var ringtoneExtension: String
    var isRepeated: Bool
}

// MARK: - class SoundPlayer

class SoundPlayer {
    
    // MARK: - Properties
    
    private var soundPlayer: AVAudioPlayer?
    private(set) var setting: SoundSetting
    
    // MARK: - Initializers
    
    init(setting: SoundSetting) {
        self.setting = setting
    }
    
    // MARK: - Methods
    
    func play() {
        stop()
        guard let url = Bundle.main.url(forResource: setting.ringtoneID, withExtension: setting.ringtoneExtension) else { return } // FIXME: - Silence error OK?
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = soundPlayer else { return }
            soundPlayer?.setVolume(1.0, fadeDuration: 3)
            if setting.isRepeated {
                player.numberOfLoops = -1
            }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func stop() {
        if soundPlayer != nil {
            soundPlayer?.stop()
            soundPlayer = nil
        }
    }
    
    func setSetting(setting: SoundSetting) {
        stop()
        self.setting = setting
    }
}
