import AudioKit

class Tuner {
    let mic: AKMicrophone
    let tracker: AKFrequencyTracker
    let silence: AKBooster
    
    let totalTickCount = 50
    let pollingInterval = 0.02
    
    var delegate: TunerDelegate?
    
    var pollingTimer: Timer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeMeasurement, options: [])
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch let error {
            print(error.localizedDescription)
        }
        
        AKSettings.audioInputEnabled = true
        mic = AKMicrophone()
        tracker = AKFrequencyTracker.init(mic)
        silence = AKBooster(tracker, gain: 0)
        
        AudioKit.output = silence
    }
    
    func start() {
        do {
            try AudioKit.start()
        } catch let error {
            print(error.localizedDescription)
        }
        
        pollingTimer = Timer.scheduledTimer(withTimeInterval: pollingInterval, repeats: true, block: {_ in self.pollingTick()})
    }
    
    func stop() {
        do {
            try AudioKit.stop()
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let t = pollingTimer {
            t.invalidate()
        }
    }
    
    private func pollingTick() {
        let frequency = Double(tracker.frequency)
        let pitch = Pitch.makePitchByFrequency(frequency)
        let delta = Double(24 * 50) * log(frequency / pitch.frequency) / log(2.0)
        
        if let d = delegate {
            d.tunerDidTick(pitch: pitch, delta: delta)
        }
    }
}

protocol TunerDelegate {
    func tunerDidTick(pitch: Pitch, delta: Double)
}
