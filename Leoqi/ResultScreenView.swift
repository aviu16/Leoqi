//import SwiftUI
//import PhotosUI
//
//struct ImageResultView: View {
//    @ObservedObject var promptMerger: PromptMerger
//    @Environment(\.presentationMode) var presentationMode
//    @State private var imageData: Data?
//    @State private var showErrorAlert = false
//    @State private var errorMessage = ""
//    @State private var isLoading = true
//    
//    var body: some View {
//        ZStack {
//            
//            if isLoading {
//                VStack {
//                    Spacer()
//                    ProgressView("Creating image...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .scaleEffect(2)
//                        .foregroundColor(.blue)
//                    Spacer()
//                }
//                .zIndex(2)
//            }
//            
//            Group {
//                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2)
//                        .clipped()
//                }
//            }
//            .opacity(imageData != nil && !isLoading ? 1 : 0)
//            .zIndex(1)
//            
//            if imageData != nil && !isLoading {
//                controlsView
//                    .transition(.opacity)
//                    .zIndex(2)
//            }
//        }
//        .alert(isPresented: $showErrorAlert) {
//            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//        }
//        .onAppear(perform: generateAndDownloadImage)
//        .navigationBarHidden(true)
//    }
//    
//    var backButton: some View {
//        Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.blue)
//                .padding()
//        }
//    }
//    
//    private var regenerateButton: some View {
//        Button(action: generateAndDownloadImage) {
//            Image(systemName: "arrow.counterclockwise.circle.fill")
//                .foregroundColor(.blue)
//                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
//                .background(Circle().fill(Color.white))
//        }
//    }
//    
//    private var downloadButton: some View {
//        Button(action: saveImageToPhotoLibrary) {
//            Image(systemName: "arrow.down.circle.fill")
//                .foregroundColor(.blue)
//                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
//                .background(Circle().fill(Color.white))
//        }
//    }
//    
//    private var publishButton: some View {
//        Button("Publish") {
//            // Implement the publish functionality here
//        }
//        .foregroundColor(.white)
//        .padding(.vertical, 10)
//        .padding(.horizontal, 20)
//        .background(Color.blue)
//        .cornerRadius(20)
//        .shadow(radius: 3) // Slightly reduced shadow for a subtler effect
//    }
//    
//    private var shareButton: some View {
//        Button(action: shareImage) {
//            Text("Share")
//                .foregroundColor(.white)
//                .padding(.vertical, 10)
//                .padding(.horizontal, 20)
//                .background(Color.blue)
//                .cornerRadius(20)
//                .shadow(radius: 3) // Slightly reduced shadow for a subtler effect
//        }
//    }
//    
//    private var controlsView: some View {
//        VStack {
//            HStack {
//                backButton
//                Spacer()
//            }
//            .padding(.top, presentationMode.wrappedValue.isPresented ? 50 : 0)
//            Spacer()
//            HStack {
//                regenerateButton
//                    .padding(.leading, 20)
//                Spacer()
//                downloadButton
//                    .padding(.trailing, 20)
//            }
//            .padding(.bottom, 20)
//            HStack(spacing: 30) {
//                publishButton
//                shareButton
//            }
//            .padding(.bottom, 50)
//        }
//    }
//    private func shareImage() {
//        guard let imageData = imageData, let uiImage = UIImage(data: imageData) else { return }
//        DispatchQueue.global(qos: .userInitiated).async {
//            let activityController = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)
//            
//            DispatchQueue.main.async {
//                if let topController = UIApplication.shared.windows.first?.rootViewController {
//                    topController.present(activityController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//    
//    private func generateAndDownloadImage() {
//        errorMessage = "Regenerating image..."
//        OpenAIService.shared.generateImage(using: promptMerger) { result in
//            DispatchQueue.main.async {
//                switch result {
//                switch result {
//                case .success(let imageUrls):
//                    if let firstImageUrl = imageUrls.first {
//                        downloadImage(from: firstImageUrl)
//                    } else {
//                        errorMessage = "No image URL returned"
//                        showErrorAlert = true
//                        isLoading = false
//                    }
//                case .failure(let error):
//                    errorMessage = "Failed to generate image: \(error.localizedDescription)"
//                    showErrorAlert = true
//                    isLoading = false
//                }
//            }
//        }
//    }
//    
//    private func downloadImage(from imageUrl: String) {
//        guard let url = URL(string: imageUrl) else {
//            DispatchQueue.main.async {
//                errorMessage = "Invalid image URL"
//                showErrorAlert = true
//                isLoading = false
//            }
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let data = data, error == nil, let _ = UIImage(data: data) {
//                    imageData = data
//                    isLoading = false
//                    showErrorAlert = false // Hide the regenerating alert once the image is ready
//                } else {
//                    errorMessage = "Failed to download image: \(error?.localizedDescription ?? "Unknown error")"
//                    showErrorAlert = true
//                    isLoading = false
//                }
//            }
//        }.resume()
//    }
//    
//    private func saveImageToPhotoLibrary() {
//        guard let imageData = imageData, let image = UIImage(data: imageData) else {
//            print("Image data is not available")
//            return
//        }
//        
//        PHPhotoLibrary.requestAuthorization { status in
//            if status == .authorized {
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAsset(from: image)
//                }) { success, error in
//                    if let error = error {
//                        print("Error saving image to photo library: \(error.localizedDescription)")
//                    } else if success {
//                        print("Image successfully saved to photo library")
//                    }
//                }
//            } else {
//                print("Photo Library access is denied by the user")
//            }
//        }
//    }
//    
//    struct CoreAppearanceView_Previews: PreviewProvider {
//        static var previews: some View {
//            ImageResultView(promptMerger: PromptMerger())
//        }
//    }
//}



import SwiftUI

struct WaveProgressView: View {
    let waveWidth: CGFloat = 2.0 // Width of the wave
    let waveCount: Int = 3 // Number of waves
    let waveHeight: CGFloat = 20.0 // Height of the wave
    @State private var animationOffset = CGSize.zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<waveCount) { index in
                    WaveShape(amplitude: waveHeight, frequency: 1.5, phase: animationOffset.width - CGFloat(index) * geometry.size.width / 3)
                        .fill(Color.blue.opacity(0.5))
                        .frame(height: geometry.size.height)
                }
            }
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    animationOffset = CGSize(width: geometry.size.width, height: 0)
                }
            }
        }
    }
}

struct WaveShape: Shape {
    var amplitude: CGFloat = 10
    var frequency: CGFloat = 1.5
    var phase: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * frequency * .pi * 2 + phase)
            let y = amplitude * sine + rect.midY

            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}
