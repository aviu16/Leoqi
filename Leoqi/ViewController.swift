import UIKit
import UnityAds

class ViewController: UIViewController, UnityAdsLoadDelegate, UnityAdsShowDelegate, UnityAdsInitializationDelegate {
    var onAdClosed: (() -> Void)?
    var onAdError: ((String) -> Void)?
    var isAdLoaded = false
    
    let unityGameID = "5587650"
    let interstitialPlacementID = "Interstitial_iOS"
    var isTestMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UnityAds.initialize(unityGameID, testMode: isTestMode, initializationDelegate: self)
    }
    
    func loadAd() {
        UnityAds.load(interstitialPlacementID, loadDelegate: self)
    }
    
    @objc func showAdButtonTapped() {
        if isAdLoaded {
            UnityAds.show(self, placementId: interstitialPlacementID, showDelegate: self)
        } else {
            print("Ad is not ready yet.")
            onAdError?("Ad is not ready yet.")
        }
    }
    
    // MARK: - UnityAdsInitializationDelegate Methods
    func initializationComplete() {
        print("Unity Ads Initialization Complete")
        loadAd()
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        print("Unity Ads Initialization Failed: \(message)")
        onAdError?("Initialization failed: \(message)")
    }
    
    // MARK: - UnityAdsLoadDelegate Methods
    func unityAdsAdLoaded(_ placementId: String) {
        print("Ad loaded: \(placementId)")
        isAdLoaded = true
    }
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        print("Ad failed to load: \(placementId) with error: \(message)")
        isAdLoaded = false
        onAdError?("Failed to load ad: \(message)")
    }
    
    // MARK: - UnityAdsShowDelegate Methods
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        print("Ad show completed with state: \(state.rawValue)")
        isAdLoaded = false
        onAdClosed?()  // Invoke the closure to signal the ad has been closed.
        loadAd()  // Preload the next ad.
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        print("Ad failed to show: \(placementId) with error: \(message)")
        isAdLoaded = false
        onAdError?("Failed to show ad: \(message)")
        loadAd()
    }
    
    func unityAdsShowStart(_ placementId: String) {
        print("Ad started showing: \(placementId)")
    }
    
    func unityAdsShowClick(_ placementId: String) {
        print("Ad clicked: \(placementId)")
    }
}
