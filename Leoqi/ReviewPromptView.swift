import SwiftUI
import UnityAds
import UIKit

struct ReviewPromptView: View {
    @ObservedObject var promptMerger: PromptMerger
    @State private var isNavigate = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var showAlert = false
    @State private var isAdReady = false
    @StateObject private var viewControllerWrapper = ViewControllerWrapper()  // Using a StateObject to wrap the ViewController
    @State private var adErrorMessage: String? = nil
    @State private var isLoading = false  // State to track loading of the a
    
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("reviewback")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing:-5) {
                    HStack {
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
                        .offset(x:-10,y:-50)
                        .padding(.leading, geometry.size.width * 0.05) // Responsive padding
                        Spacer()
                        VStack {
                            Text("Step 4")
                                .font(Font.custom("Inter", size: 24).weight(.heavy))
                                .foregroundColor(.white)
                                .offset(x:-25,y:-35)
                            Text("Review Prompt")
                                .font(Font.custom("Inter", size: 20).weight(.heavy))
                                .foregroundColor(.white.opacity(0.87))
                                .offset(x:-110,y:25)
                        }
                        Spacer()
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                    
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(
                            width: min(geometry.size.width * 0.9, 400), // This prevents the rectangle from getting too wide on iPads.
                            height: min(geometry.size.height * 1, 400) // This prevents the rectangle from getting too tall on iPads.
                        )
                        .background(colorScheme == .dark ? Color.black.opacity(0.62) : Color(red: 0.86, green: 0.80, blue: 0.80).opacity(0.62))
                        .cornerRadius(12)
                        .overlay(
                            ScrollView {
                                VStack {
                                    Text(promptMerger.generatePrompt())
                                        .padding()
                                }
                            }
                        )
                        .padding(.top, geometry.size.height * 0.12)
                    
                    
                    
                    //                    Image("spiral")
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25) // Responsive size
                    //                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                    //                        .offset(y:12)
                    ScrollView {
                        Button(action: {
                            print("Generate button tapped")
                            if promptMerger.generatePrompt().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showAlert = true
                            } else {
                                if viewControllerWrapper.viewController.isAdLoaded {
                                    viewControllerWrapper.viewController.onAdClosed = {
                                        DispatchQueue.main.async {
                                            print("Ad closed")
                                            isNavigate = true  // Triggers navigation
                                        }
                                    }
                                    viewControllerWrapper.viewController.onAdError = { message in
                                        DispatchQueue.main.async {
                                            print("Ad error: \(message)")
                                            adErrorMessage = message  // Triggers alert
                                        }
                                    }
                                    // Show the ad on the most front view controller
                                    if let viewController = UIApplication.getFrontMostViewController() {
                                        UnityAds.show(viewController, placementId: viewControllerWrapper.viewController.interstitialPlacementID, showDelegate: viewControllerWrapper.viewController)
                                    } else {
                                        print("No view controller is available to present the ad.")
                                    }
                                } else {
                                    print("Ad is not ready to be shown, attempting to load.")
                                    isLoading = true  // Set loading state to true
                                    viewControllerWrapper.viewController.loadAd()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        isLoading = false  // Set loading state to false after delay
                                        if viewControllerWrapper.viewController.isAdLoaded {
                                            if let viewController = UIApplication.getFrontMostViewController() {
                                                UnityAds.show(viewController, placementId: viewControllerWrapper.viewController.interstitialPlacementID, showDelegate: viewControllerWrapper.viewController)
                                            }
                                        } else {
                                            print("Ad still not ready after loading attempt.")
                                        }
                                    }
                                }
                            }
                        }) {
                            if isLoading {
                                ProgressView()  // Show loading indicator when loading
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                            }
                            
                            else {
                                Text("Generate")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.5, height: 50)
                        .background(Color.black.opacity(0.20))
                        .cornerRadius(25)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(y: 90)
                        .zIndex(1) // Ensures the button is layered above other views
                        //                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Error"),
                                message: Text("No prompt available. Please provide the necessary details to generate a prompt."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        .alert(isPresented: Binding<Bool>.constant(adErrorMessage != nil)) {
                            Alert(
                                title: Text("Ad Error"),
                                message: Text(adErrorMessage ?? "Unknown error"),
                                dismissButton: .default(Text("OK"), action: {
                                    adErrorMessage = nil
                                })
                            )
                        }
                        NavigationLink(destination: IResultView(promptMerger: self.promptMerger).navigationBarBackButtonHidden(true), isActive: $isNavigate) {
                            EmptyView()
                        }
                        .hidden()
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, geometry.size.width * 0.05) // Responsive padding
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
    
    
    struct ReviewPromptView_Previews: PreviewProvider {
        static var previews: some View {
            ReviewPromptView(promptMerger: PromptMerger())
        }
    }
}
