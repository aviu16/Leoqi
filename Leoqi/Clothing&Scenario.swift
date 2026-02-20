import SwiftUI

struct ClothScenView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var promptMerger: PromptMerger
    @State private var garmentType = ""
    @State private var gear = ""
    @State private var accessories = ""
    @State private var setting = ""
    @State private var action = ""
    @State private var emotion = ""
    @State private var isNavigate = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var activeField: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("clothback")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing:40) {
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
                            Text("Step 2")
                                .font(Font.custom("Inter", size: 24).weight(.heavy))
                                .foregroundColor(.white)
                                .offset(x:-5,y:-35)
                            Text("Clothing & Scenario")
                                .font(Font.custom("Inter", size: 20).weight(.heavy))
                                .foregroundColor(.white.opacity(0.87))
                                .offset(x:-80,y:70)
                        }
                        Spacer()
                        ShuffleDice(action: {
                            RandomizerUI.shuffleClothScen(promptMerger: promptMerger)
                        })
                        .offset(x: -10, y: 70) // Adjust the offset as needed
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                    
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 10) {
                            CustomTextField(placeholder: "Main Outfit (Brown leather armor)", text: $promptMerger.garmentType, activeField: $activeField, fieldIndex: 0, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Gear (Necklace, Walking staff)", text: $promptMerger.gear, activeField: $activeField, fieldIndex: 1, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Accessories (Pack, Bandolier of vials)", text: $promptMerger.accessories, activeField: $activeField, fieldIndex: 2, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Setting (Inside a futuristic space station)", text: $promptMerger.setting, activeField: $activeField, fieldIndex: 3, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Action (Dueling with a shadowy figure)", text: $promptMerger.action, activeField: $activeField, fieldIndex: 4, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Emotion (Lost in a moment of sorrow)", text: $promptMerger.emotion, activeField: $activeField, fieldIndex: 5, scrollViewOffset: $scrollViewOffset)
                        }
                        .padding(.top,40)
                        .padding(.horizontal, geometry.size.width * 0.01)
                        .padding(.bottom, keyboardHeight)
                        
                        .offset(y: -scrollViewOffset)
                        .animation(.easeOut(duration: 0.3), value: scrollViewOffset)
                        .onAppear {
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notif in
                                let value = notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                                let height = value.height
                                keyboardHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                            }
                            
                            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                                keyboardHeight = 0
                                scrollViewOffset = 0
                            }
                        }
                        Spacer()
                        //                        Image("spiral")
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25) // Responsive size
                        //                            .padding(.bottom, geometry.safeAreaInsets.bottom)
                        //                            .offset(y:12)
                        
                        Button(action: {
                            isNavigate = true
                        }) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.5, height: 50) // Responsive width
                        .background(Color.black.opacity(0.20))
                        .cornerRadius(25)
                 
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(y:110)
                        .zIndex(1) // Ensures the button is layered above other views
                    
//                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                        NavigationLink(destination: ImageStyleView(promptMerger: self.promptMerger).navigationBarBackButtonHidden(true), isActive: $isNavigate) {
                            EmptyView()
                        }
                        .hidden()
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .padding(.horizontal, geometry.size.width * 0.05) // Responsive padding
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme
    @Binding var activeField: Int?
    var fieldIndex: Int
    @Binding var scrollViewOffset: CGFloat
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
        //            .frame(maxWidth: .infinity)
            .background(colorScheme == .dark ? Color.black : Color(red: 0.86, green: 0.80, blue: 0.80))
            .cornerRadius(10)
            .foregroundColor(Color.primary)
        //            .padding(.horizontal)
        // No fixed width here; it will expand to fill its container
            .onTapGesture {
                            self.activeField = fieldIndex
                            // Adjust scrollViewOffset based on the fieldIndex
                            // This calculation needs to be adjusted based on your UI
                            scrollViewOffset = CGFloat(fieldIndex * 10) // Example calculation
                        }
    }
}

    
    
    // Preview for CoreAppearanceView
    struct ClothScenAppearanceView_Previews: PreviewProvider {
        static var previews: some View {
            ClothScenView(promptMerger: PromptMerger())
        }
    }

