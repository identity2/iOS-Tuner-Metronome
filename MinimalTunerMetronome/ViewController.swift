import GoogleMobileAds
import UIKit

class ViewController: UIViewController, GADBannerViewDelegate {

    // MARK: Views.
    @IBOutlet weak var leftButtonView: UIButton!
    @IBOutlet weak var rightButtonView: UIButton!
    @IBOutlet weak var toggleView: ToggleView!
    @IBOutlet weak var metronomeView: MetronomeAnimationView!
    @IBOutlet weak var smallScreenView: UIImageView!
    @IBOutlet weak var tempoView: SmallScreenView!
    @IBOutlet weak var tunerView: TunerView!
    
    var adBannerView: GADBannerView!
    
    // MARK: Constants.
    let defaultBPM = 80
    let fastAdjustInterval = 0.2
    
    // MARK: Properties.
    weak var bpmAdjustTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(adBannerView)
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "15338fef8420ce834b432ce21af4af4a"]
        adBannerView.adUnitID = "ca-app-pub-3679599074148025/7729845973"
        adBannerView.rootViewController = self
        adBannerView.delegate = self
        adBannerView.load(GADRequest())
        
        toggleView.addTarget(self, action: #selector(ViewController.toggleValueChanged(toggleView:)), for: .valueChanged)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        print(bannerView.frame.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUpTuner()
        shutDownMetronome()
        
        tempoView.positionSubviews()
        metronomeView.positionSubviews()
        toggleView.positionSubviews()
        tunerView.positionSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions.
    @IBAction func leftButtonDown(_ sender: UIButton) {
        adjustBPM(positive: false)
        invalidateBPMAdjustTimer()
        bpmAdjustTimer = Timer.scheduledTimer(withTimeInterval: fastAdjustInterval, repeats: true, block: {_ in self.fastAdjustBPM(positive: false)})
    }
    
    @IBAction func leftButtonUpInside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func leftButtonUpOutside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func rightButtonDown(_ sender: UIButton) {
        adjustBPM(positive: true)
        invalidateBPMAdjustTimer()
        bpmAdjustTimer = Timer.scheduledTimer(withTimeInterval: fastAdjustInterval, repeats: true, block: {_ in self.fastAdjustBPM(positive: true)})
    }
    @IBAction func rightButtonUpOutside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func rightButtonUpInside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @objc func toggleValueChanged(toggleView: ToggleView) {
        if toggleView.inLeft {
            // Tuner.
            startUpTuner()
            shutDownMetronome()
        } else {
            // Metronome.
            shutDownTuner()
            startUpMetronome()
        }
    }
    
    // MARK: Functions.
    private func startUpMetronome() {
        leftButtonView.isHidden = false
        rightButtonView.isHidden = false
        smallScreenView.isHidden = false
        tempoView.isHidden = false
        metronomeView.isHidden = false
        
        metronomeView.startMetronome(bpm: tempoView.currTempo)
    }
    
    private func shutDownMetronome() {
        leftButtonView.isHidden = true
        rightButtonView.isHidden = true
        smallScreenView.isHidden = true
        tempoView.isHidden = true
        metronomeView.isHidden = true
        
        metronomeView.stopMetronome()
    }
    
    private func startUpTuner() {
        tunerView.isHidden = false
        
        tunerView.startTuner()
    }
    
    private func shutDownTuner() {
        tunerView.isHidden = true
        
        tunerView.stopTuner()
    }
    
    private func adjustBPM(positive: Bool) {
        tempoView.changeValue(positive: positive)
        metronomeView.updateBPM(tempoView.currTempo)
    }
    
    @objc private func fastAdjustBPM(positive: Bool) {
        tempoView.changeValue(positive: positive, fastChanging: true)
        metronomeView.updateBPM(tempoView.currTempo)
    }
    
    private func invalidateBPMAdjustTimer() {
        if let timer = bpmAdjustTimer {
            timer.invalidate()
        }
    }
    
    // Ad delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Received Ad")
    }
    
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("Will present Ad.")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed, error: \(error.description)")
    }
}

