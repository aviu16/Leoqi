//import SwiftUI
//
//struct CharacterCreationView: View {
//    @State private var currentStep = 1
//    @StateObject private var promptMerger = PromptMerger()
//    @Environment(\.presentationMode) var presentationMode
//    
//    var body: some View {
//        
//        VStack {
//            // Custom Header with Back Arrow for all steps
//            HStack {
//                Button(action: {
//                    if currentStep > 1 {
//                        currentStep -= 1
//                    } else {
//                        // Navigate back to a previous view or dismiss the modal
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }) {
//                    Image(systemName: "chevron.left") // System image for back icon
//                        .foregroundColor(.blue)
//                        .padding()
//                }
//                Spacer()
//            }
//            .padding(.horizontal)
//            
//            Group {
//                switch currentStep {
//                case 1:
//                    CoreAppearanceView(promptMerger: promptMerger)
//                case 2:
//                    ClothingView(promptMerger: promptMerger)
//                case 3:
//                    ImageStyleView(promptMerger: promptMerger)
//                case 4:
//                    ScenarioView(promptMerger: promptMerger)
//                case 5:
//                    ReviewPromptView(promptMerger: promptMerger)
//                default:
//                    Text("Unknown step")
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding()
//            
//            // Next button for navigating forward
//            if currentStep < 5 {
//                Button(action: {
//                    currentStep += 1
//                })
//                {
//                    Text("Next")
//                        .font(Font.custom("Inter", size: 18).weight(.bold))
//                        .foregroundColor(.white)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 40)
//                        .frame(width: 176, height: 50)
//                        .background(Color.black.opacity(0.20))
//                        .cornerRadius(50)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 50)
//                                .stroke(Color.white, lineWidth: 1)
//                            
//                        )
//                }
//                .navigationBarHidden(true) // Ensure the default navigation bar is hidden
//            }
//            
//        }
//    }
//    
//    struct CoreAppearanceView: View {
//        @ObservedObject var promptMerger: PromptMerger
//        @State private var genderPresentation = ""
//        @State private var ageDescriptor = ""
//        @State private var race = ""
//        @State private var species = ""
//        @State private var hairTexture = ""
//        @State private var hairColor = ""
//        @State private var hairLength = ""
//        @State private var skinTone = ""
//        @State private var earType = ""
//        @State private var eyeColor = ""
//        @State private var cheekType = ""
//        @State private var faceShape = ""
//        @State private var additionalFeatures = ""
//        
//        var body: some View {
//            ZStack {
//                Image("coreback") // Background image
//                    .resizable()
//                    .scaledToFill()
//                .edgesIgnoringSafeArea(.all)}
//            
//            VStack {
//                // Header
//                HStack {
//                    Spacer()
//                    Text("Step 1")
//                        .font(Font.custom("Inter", size: 24).weight(.heavy))
//                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
//                    Spacer()
//                }
//                
//                Text("Core Appearance")
//                    .font(Font.custom("Inter", size: 24).weight(.heavy))
//                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.87))
//                
//                // Text fields
//                ForEach(0..<10) { _ in // Replace with actual number of fields you have
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color(red: 0.86, green: 0.80, blue: 0.80))
//                        TextField("Gender Presentation (e.g., Feminine, Boyish)", text: .constant(""))
//                            .font(Font.custom("Inter", size: 14).weight(.bold))
//                            .foregroundColor(Color(red: 0.48, green: 0.48, blue: 0.48))
//                            .padding(.horizontal)
//                        
//                    }
//                    .frame(height: 40)
//                }
//                
//                Spacer()
//                
//                
//            }
//            .padding()
//        }
//    }
//    
//    
//    
//    
//    
//    struct ClothingView: View {
//        @ObservedObject var promptMerger: PromptMerger
//        @State private var garmentType = ""
//        @State private var materialTexture = ""
//        @State private var color = ""
//        @State private var patternDesign = ""
//        @State private var accessoriesItems = ""
//        @State private var headwear = ""
//        @State private var footwear = ""
//        @State private var handwear = "" // Combined Gloves and Gauntlets
//        @State private var outerwear = "" // Combined Capes and Cloaks
//        @State private var jewelryOrnaments = ""
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Clothing (all fields are optional)").font(.headline)
//                
//                TextField("Garment Type (e.g., Tunic, Armor)", text: $promptMerger.garmentType)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Material and Texture (e.g., Leather, Silk)", text: $promptMerger.materialTexture)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Color (e.g., Red, Black)", text: $promptMerger.color)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Patterns and Designs (e.g., Floral, Embroidered)", text: $promptMerger.patternDesign)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Accessories (e.g., Sword)", text: $promptMerger.accessoriesItems)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Headwear (e.g., Wide-brimmed Hat, Helmet)", text: $promptMerger.headwear)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Footwear (e.g., Leather Boots, Sandals)", text: $promptMerger.footwear)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Handwear (e.g., Gloves, Gauntlets)", text: $promptMerger.handwear)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Outerwear (e.g., Cape, Cloak)", text: $promptMerger.outerwear)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                TextField("Jewelry (e.g., Necklace, Earrings)", text: $promptMerger.jewelryOrnaments)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//        }
//    }
//    
//    
//    struct ImageStyleView: View {
//        @ObservedObject var promptMerger: PromptMerger
//        @State private var selectedStyles = Set<String>()
//        
//        let shadingStyles = ["Gradient", "Cell", "Soft", "Realistic", "Stippling"]
//        let lineworkStyles = ["Clean", "Bold", "Inked", "Sketchy", "Detailed"]
//        let colorPalettes = ["Vibrant", "Muted", "Pastel", "Monochrome", "Earth Tones"]
//        let textureStyles = ["Smooth", "Brush Stroke", "Patterned", "Grunge", "Glossy"]
//        let proportionsFeatures = ["Stylized", "Realistic", "Heroic", "Exaggerated", "Simplified"]
//        let lightingContrasts = ["Dramatic", "High Contrast", "Atmospheric", "Soft", "Shadow Play"]
//        
//        var body: some View {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 10) {
//                    Group {
//                        Text("Image Style (choose up to 4)")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        styleCategoryView("Shading Styles", options: shadingStyles)
//                        styleCategoryView("Linework", options: lineworkStyles)
//                        styleCategoryView("Color Palettes", options: colorPalettes)
//                        styleCategoryView("Textures", options: textureStyles)
//                        styleCategoryView("Proportions and Features", options: proportionsFeatures)
//                        styleCategoryView("Lighting and Contrast", options: lightingContrasts)
//                    }
//                    .padding(.horizontal)
//                }
//            }
//        }
//        
//        private func styleCategoryView(_ title: String, options: [String]) -> some View {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .padding(.vertical, 5)
//                
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 10) {
//                    ForEach(options, id: \.self) { style in
//                        OptionButton(
//                            style: style,
//                            isSelected: selectedStyles.contains(style),
//                            action: {
//                                if selectedStyles.contains(style) {
//                                    selectedStyles.remove(style)
//                                } else if selectedStyles.count < 4 {
//                                    selectedStyles.insert(style)
//                                }
//                            }
//                        )
//                    }
//                }
//                .padding(.bottom, 10)
//            }
//        }
//    }
//    
//    struct OptionButton: View {
//        var style: String
//        var isSelected: Bool
//        var action: () -> Void
//        
//        var body: some View {
//            Text(style)
//                .font(.caption)
//                .padding(8)
//                .frame(minWidth: 70)
//                .foregroundColor(isSelected ? .white : .black)
//                .background(isSelected ? Color.blue : Color(UIColor.systemGray6))
//                .cornerRadius(8)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray, lineWidth: isSelected ? 0 : 1)
//                )
//                .onTapGesture(perform: action)
//        }
//    }
//    
//    
//    
//    
//    struct ScenarioView: View {
//        @ObservedObject var promptMerger: PromptMerger
//        @State private var setting = ""
//        @State private var action = ""
//        @State private var emotion = ""
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Scenario (all fields are optional)").font(.headline)
//                    .padding()
//                    .background(Color(UIColor.secondarySystemBackground))
//                    .cornerRadius(12)
//                
//                TextField("Setting (e.g., in a forest, at a tavern)", text: $promptMerger.setting)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.bottom, 5)
//                    .background(Color(UIColor.secondarySystemBackground))
//                    .cornerRadius(12)
//                
//                TextField("Action (e.g., fighting a dragon, studying a map)", text: $promptMerger.action)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.bottom, 5)
//                    .background(Color(UIColor.secondarySystemBackground))
//                    .cornerRadius(12)
//                
//                TextField("Emotion (e.g., joyfully, angrily)", text: $promptMerger.emotion)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(.bottom, 5)
//                    .background(Color(UIColor.secondarySystemBackground))
//                    .cornerRadius(12)
//            }
//            .padding()
//            .background(Color(UIColor.secondarySystemBackground))
//            .cornerRadius(12)
//        }
//    }
//    
//    
//    struct ReviewPromptView: View {
//        @ObservedObject var promptMerger: PromptMerger
//        @State private var isNavigatingToImageResult = false
//        
//        var body: some View {
//            VStack {
//                Text("Review Your Character")
//                    .font(.title)
//                    .padding()
//                
//                ScrollView {
//                    Text(promptMerger.generatePrompt())
//                        .padding()
//                }
//                
//                Button("Create Image") {
//                    // Trigger navigation to ImageResultView
//                    self.isNavigatingToImageResult = true
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                
//                // Direct navigation to ImageResultView, where the image generation will occur
//                NavigationLink(destination: ImageResultView(promptMerger: promptMerger), isActive: $isNavigatingToImageResult) {
//                    EmptyView()
//                }
//                
//            }
//            .navigationBarTitle("Review and Generate")
//        }
//    }
//    
//    
//    
//    struct FilledButtonStyle: ButtonStyle {
//        var backgroundColor: Color
//        
//        func makeBody(configuration: Self.Configuration) -> some View {
//            configuration.label
//                .foregroundColor(.white)
//                .padding()
//                .background(backgroundColor)
//                .cornerRadius(8)
//                .scaleEffect(configuration.isPressed ? 0.95 : 1)
//        }
//    }
//    
//    
//    struct CharacterCreationView_Previews: PreviewProvider {
//        static var previews: some View {
//            CharacterCreationView()
//        }
//    }
//}
//
