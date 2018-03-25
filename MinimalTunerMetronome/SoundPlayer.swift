import AVFoundation
import UIKit

class SoundPlayer {
    var player: AVAudioPlayer!
    
    init(soundName: String) {
        guard let soundAsset = NSDataAsset(name: soundName) else {
            fatalError("Error loading sound for metronome.")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: AVFileType.wav.rawValue)
            player.prepareToPlay()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSound() {
        player.play()
    }
}
