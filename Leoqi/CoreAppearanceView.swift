import SwiftUI

struct CoreAppearanceView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var promptMerger: PromptMerger
    @State private var genderPresentation = ""
    @State private var ageDescriptor = ""
    @State private var charactertype = ""
    @State private var hairdetails = ""
    @State private var skinTone = ""
    @State private var earType = ""
    @State private var eyedetails = ""
    @State private var cheekType = ""
    @State private var bodyShape = ""
    @State private var faceShape = ""
//    @State private var additionalFeatures = ""
    @State private var isNavigate = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var scrollViewOffset: CGFloat = 0
    @State private var activeField: Int? = nil
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("coreback")
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
                            Text("Step 1")
                                .font(Font.custom("Inter", size: 24).weight(.heavy))
                                .foregroundColor(.white)
                                .offset(x:-5,y:-38)
                            Text("Core Appearance")
                                .font(Font.custom("Inter", size: 20).weight(.heavy))
                                .foregroundColor(.white.opacity(0.87))
                                .offset(x:-88,y:20)
                        }
                        Spacer()
                        
                        ShuffleDice(action: {
                            RandomizerUI.shuffleCoreAppearance(promptMerger: promptMerger)
                        })
                        .offset(x: -10, y: 20) // Adjust the offset as needed
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                    
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 10) {
                            Spacer().frame(height: 30)// Adjust spacing as needed
                            CustomTextField(placeholder: "Gender Presentation (Feminine, Boyish)", text: $promptMerger.genderPresentation,activeField: $activeField, fieldIndex: 0, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Character Type (Elf Wizard, Human Monk)", text: $promptMerger.charactertype,activeField: $activeField, fieldIndex: 1, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Age Descriptor (Youthful)", text: $promptMerger.ageDescriptor,activeField: $activeField, fieldIndex: 2, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Hair (Long curly blonde)", text: $promptMerger.hairdetails,activeField: $activeField, fieldIndex: 3, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Eye Color (Green-eyed)", text: $promptMerger.eyedetails,activeField: $activeField, fieldIndex: 4, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Skin Tone (Crimson-skinned)", text: $promptMerger.skinTone,activeField: $activeField, fieldIndex: 5, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Body Shape (Tall, Slender,)", text: $promptMerger.bodyShape,activeField: $activeField, fieldIndex: 6, scrollViewOffset: $scrollViewOffset)
                            CustomTextField(placeholder: "Face (Freckled round face, fluffy cheeks)", text: $promptMerger.faceShape,activeField: $activeField, fieldIndex: 7, scrollViewOffset: $scrollViewOffset)
                            //                            CustomTextField(placeholder: "Additional Features (Tattoos,Horns)", text: $promptMerger.additionalFeatures,activeField: $activeField, fieldIndex: 8, scrollViewOffset: $scrollViewOffset)
                        }
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
                        //                            .offset(y:10)
                        
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
                        .offset(y:10)
                        .zIndex(1) // Ensures the button is layered above other views
                    
//                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                        NavigationLink(destination: ClothScenView(promptMerger: self.promptMerger).navigationBarBackButtonHidden(true), isActive: $isNavigate) {
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
                .onTapGesture {
                    self.activeField = fieldIndex
                    // Adjust scrollViewOffset based on the fieldIndex
                    // This calculation needs to be adjusted based on your UI
                    scrollViewOffset = CGFloat(fieldIndex * 25) // Example calculation
                }
            //            .padding(.horizontal)
            // No fixed width here; it will expand to fill its container
        }
    }
    
    
    // Preview for CoreAppearanceView
    struct CoreAppearanceView_Previews: PreviewProvider {
        static var previews: some View {
            CoreAppearanceView(promptMerger: PromptMerger())
        }
    }
    
}
