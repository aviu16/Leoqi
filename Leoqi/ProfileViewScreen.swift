import SwiftUI
import PhotosUI
import UIKit
import UnityAds

struct IResultView: View {
    @ObservedObject var promptMerger: PromptMerger
    @Environment(\.presentationMode) var presentationMode
    @State private var imageData: Data?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = true
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @StateObject private var viewControllerWrapper = ViewControllerWrapper()  // Using a StateObject to wrap the ViewController
//    @State private var regenerationTriggered = false

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("resultback") // Replace with your actual background image
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // Always-visible back button and title
                VStack {
                    HStack {
                        backButton
                            .offset(x:10,y:0)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Your Character")
                            .font(Font.custom("Inter", size: 24).weight(.heavy))
                            .foregroundColor(.white)
                    }
                    .offset(x:-100,y:-40)
                    
                    Spacer()
                }
                .zIndex(2)
            
                
                // Image and buttons appear after loading
                ScrollView{
                    if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                        VStack {
                            Spacer(minLength: geometry.safeAreaInsets.top + 60) // Adjust the space for the title bar
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Changed to .fill to ensure the image covers the entire area
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                                .clipped() // Ensures the image does not exceed its bounds
                                .cornerRadius(20)
                                .overlay(
                                    // Overlaying the download icon at the bottom-right of the image
                                    Button(action: {
                                        saveImageToPhotoLibrary()
                                    }) {
                                        Image(systemName: "arrow.down.circle.fill") // System name for the download icon
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                            .shadow(radius: 10) // Optional: Adds a shadow for better visibility
                                    }
                                        .padding([.bottom, .trailing], 16), // Adjust padding to position the icon correctly
                                    alignment: .bottomTrailing
                                )
                            Spacer()
                            regenerateButton
                            shareButton
                        }
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                        .transition(.opacity)
                    } else {
                        loadingView
                    }
                }
                .zIndex(1)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: generateAndDownloadImage)
            .navigationBarHidden(true)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                Ellipse()
                    .fill(Color.gray)
                    .frame(width: 36, height: 36)
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, presentationMode.wrappedValue.isPresented ? 20 : 0) // Add padding to account for the safe area
        .padding(.leading,20) // Add padding to place the button on the left side
    }
    
    
    private var loadingView: some View {
        VStack {
            Spacer()
            WaveProgressView()
                .frame(height: 800) // You can adjust the height as needed
//                .padding(.top,700)
            Text("Creating image...")
                .foregroundColor(.white)
                .padding(.top,-380)
            Spacer()
        }
    }


    @State private var lastGenerationTime: Date? = nil
    let regenerationCooldown: TimeInterval = 5 // 5 seconds cooldown

    private var regenerateButton: some View {
        Button(action: {
            isLoading = true
            imageData = nil
            let now = Date()

            // Check if we're within the cooldown period
            if let lastGenTime = lastGenerationTime, now.timeIntervalSince(lastGenTime) < regenerationCooldown {
                print("Regeneration cooldown in effect.")
                return
            }

            if viewControllerWrapper.viewController.isAdLoaded {
                viewControllerWrapper.viewController.onAdClosed = {
                    DispatchQueue.main.async {
                        if Date().timeIntervalSince(now) >= regenerationCooldown {
                            print("Ad closed after regeneration")
//                            generateAndDownloadImage()
                            lastGenerationTime = Date() // Update the last generation time
                        }
                    }
                }
                viewControllerWrapper.viewController.onAdError = { message in
                    DispatchQueue.main.async {
                        if Date().timeIntervalSince(now) >= regenerationCooldown {
                            print("Ad error during regeneration: \(message)")
//                            generateAndDownloadImage()
                            lastGenerationTime = Date() // Update the last generation time
                        }
                    }
                }
                if let viewController = UIApplication.getFrontMostViewController() {
                    UnityAds.show(viewController, placementId: viewControllerWrapper.viewController.interstitialPlacementID, showDelegate: viewControllerWrapper.viewController)
                } else {
                    print("No view controller is available to present the ad during regeneration.")
//                    generateAndDownloadImage()
                    lastGenerationTime = Date() // Update immediately if no ad is shown
                }
            } else {
                print("Ad is not ready to be shown during regeneration")
//                generateAndDownloadImage()
                lastGenerationTime = Date() // Update immediately if no ad is loaded
            }
        }){
            Text("Regenerate")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.20))
                .cornerRadius(25)
                .buttonStyle(PlainButtonStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white, lineWidth: 2)
                )
                .offset(x:-80,y:5)
        }
    }
    
    private var shareButton: some View {
        Button(action: shareImage) {
            Text("Share")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.20))
        .cornerRadius(25)
        .buttonStyle(PlainButtonStyle())
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white, lineWidth: 2)
        )
        .offset(x:100, y:-60)
    }
    
    private func shareImage() {
        guard let imageData = imageData, let uiImage = UIImage(data: imageData) else { return }
        
        // Ensuring UI operations are dispatched on the main thread
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
            
            // Presenting the activity controller
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(activityController, animated: true, completion: nil)
            }
        }
    }
    
    
    private func generateAndDownloadImage() {
        errorMessage = "Regenerating image..."
        OpenAIService.shared.generateImage(using: promptMerger) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageUrls):
                    if let firstImageUrl = imageUrls.first {
                        downloadImage(from: firstImageUrl)
                    } else {
                        errorMessage = "No image URL returned"
                        showErrorAlert = true
                        isLoading = false
                    }
                case .failure(let error):
                    errorMessage = "Failed to generate image: \(error.localizedDescription)"
                    showErrorAlert = true
                    isLoading = false
                }
            }
        }
    }
    private func downloadImage(from imageUrl: String) {
        guard let url = URL(string: imageUrl) else {
            DispatchQueue.main.async {
                errorMessage = "Invalid image URL"
                showErrorAlert = true
                isLoading = false
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, error == nil, let _ = UIImage(data: data) {
                    imageData = data
                    isLoading = false
                    showErrorAlert = false // Hide the regenerating alert once the image is ready
                } else {
                    errorMessage = "Failed to download image: \(error?.localizedDescription ?? "Unknown error")"
                    showErrorAlert = true
                    isLoading = false
                }
            }
        }.resume()
    }
    private func saveImageToPhotoLibrary() {
        guard let imageData = imageData, let image = UIImage(data: imageData) else {
            alertTitle = "Error"
            alertMessage = "Image data is not available"
            showAlert = true
            print("Image data is not available")
            return
        }

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, error in
                        if let error = error {
                            self.alertTitle = "Error"
                            self.alertMessage = "Error saving image to photo library: \(error.localizedDescription)"
                            self.showAlert = true
                            print("Error saving image to photo library: \(error.localizedDescription)")
                        } else if success {
                            self.alertTitle = "Success"
                            self.alertMessage = "Image successfully saved to photo library"
                            self.showAlert = true
                            print("Image successfully saved to photo library")
                        }
                    }
                case .denied, .restricted:
                    alertTitle = "Access Denied"
                    alertMessage = "Photo Library access is denied or restricted by the user"
                    showAlert = true
                    print("Photo Library access is denied or restricted by the user")
                case .limited:
                    alertTitle = "Access Limited"
                    alertMessage = "Photo Library access is limited by the user"
                    showAlert = true
                    print("Photo Library access is limited by the user")
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
        }
    }

    class ViewControllerWrapper: ObservableObject {
            @Published var viewController: ViewController

            init() {
                viewController = ViewController()  // Instantiate the ViewController
                viewController.loadAd()  // Instantiate the ViewController
            }
        }
    }
    
    
    
    
    
    struct IResultView_Previews: PreviewProvider {
        static var previews: some View {
            IResultView(promptMerger: PromptMerger())
        }
    }

