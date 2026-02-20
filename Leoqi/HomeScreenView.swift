import SwiftUI

struct HomeScreenView: View {
    @State private var isNavigate = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack {
                // Background image with blur
                Image("background") // Ensure this is the correct asset name in your Xcode project
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 4)
                    .edgesIgnoringSafeArea(.all)
                
                // Semi-transparent purple overlay
                Color(red: 0.50, green: 0.39, blue: 0.50)
                    .blendMode(.color)
                    .opacity(0.69)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 100)
                
                // Spiral image
                Image("spiral") // Ensure this is the correct asset name in your Xcode project
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330.98, height: 329)
                    .offset(y: 200) // Adjust this value to position the spiral image
                
                VStack {
                    Spacer()
                    
                    Text("Create")
                        .font(Font.custom("Inter", size: 48).weight(.heavy)) // Adjust weight for bolder text
                        .foregroundColor(.white)
                        .offset(y: 165)
                    Text("Characters")
                        .font(Font.custom("Inter", size: 48).weight(.heavy)) // Adjust weight for bolder text
                        .foregroundColor(.white)
                        .padding(.bottom, -20)// Space before the button
                        .offset(y: 150)
                    
                    Button(action: {
                        isNavigate = true
                    }) {
                        Text("Get Started")
                            .font(Font.custom("Inter", size: 20).weight(.heavy)) // Adjust weight for bolder text
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32))
                    .frame(width: 318, height: 55)
                    .background(Color.black.opacity(0.20))
                    .cornerRadius(100)
       
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(Color.white, lineWidth: 2) // Set the stroke width to 2
                            .buttonStyle(PlainButtonStyle())
                    )
                    .offset(y: 188)
                    .zIndex(1) // Ensures the button is layered above other views
             
                    
                    Spacer()
                    
                }
//                .edgesIgnoringSafeArea(.bottom)
                
                // Navigation
                NavigationLink(destination: CoreAppearanceView(promptMerger: PromptMerger()).navigationBarBackButtonHidden(true), isActive: $isNavigate) {
                    EmptyView()
                }
                
                .hidden()
    
      
            }
//            navigationBarHidden(true)
        }
        
    }
    struct HomeScreenView_Previews: PreviewProvider {
        static var previews: some View {
            HomeScreenView()
        }
    }
}
