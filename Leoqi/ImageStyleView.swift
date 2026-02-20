import SwiftUI

struct ImageStyleView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var promptMerger: PromptMerger
    @State private var isNavigate = false
    @State private var selectedStyles = Set<String>() // Tracks selected styles by ID

    // Sample style options
    let styleOptions: [StyleOption] = [
        StyleOption(name: "Cell Shading"),StyleOption(name: "Brushed Textures") ,StyleOption(name: "Soft Shading"),
        StyleOption(name: "Inked Linework"),StyleOption(name: "Patterned Textures"),StyleOption(name: "Dramatic"),StyleOption(name: "Realistic Shading "),StyleOption(name: "Vibrant Palette"),StyleOption(name: "Muted Palette"),StyleOption(name: "Bold Linework"),StyleOption(name: "Pastel Colors"),StyleOption(name: "Smooth Textures"),StyleOption(name: "Stylized Proportion"),StyleOption(name: "High Contrast"),StyleOption(name: "Atmospheric"),StyleOption(name: "Stippling"),StyleOption(name: "Clean lines"),StyleOption(name: "Realistic Proportion")
    ]

    var body: some View {
         GeometryReader { geometry in
             ZStack {
                 Image("imagestyleback")
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
                         .offset(x:-5,y:-82)
                         .padding(.leading, geometry.size.width * 0.05) // Responsive padding
                         Spacer()
                         
                         VStack(alignment: .leading) {
                             Text("Step 3")
                                 .font(Font.custom("Inter", size: 24).weight(.heavy))
                                 .foregroundColor(.white)
                                 .offset(x:90,y:-70)
                             // Adjusted HStack for "Image Style" and counter text
                             HStack {
                                 Text("Image Style")
                                     .font(Font.custom("Inter", size: 20).weight(.heavy))
                                     .foregroundColor(.white.opacity(0.87))
                                     .offset(x:-50,y:0)
                                 
                                 Spacer() // Pushes the counter text to the right of "Image Style"
                                 
                                 Text("\(selectedStyles.count) of 4")
                                     .font(Font.custom("Inter", size: 18))
                                     .foregroundColor(.white)
                             }
                         }
                         Spacer()
                     }
                     .padding(.top, geometry.safeAreaInsets.top + 20)

                     ScrollView {
                         WrapGridView(styleOptions: styleOptions, selectedStyles: $selectedStyles)
                             .padding(.horizontal)
                             .padding(.top,30)
       
//                         Image("spiral")
//                             .resizable()
//                             .scaledToFit()
//                             .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
//                             .padding(.top, 20)
//                             .offset(y: 18)

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
                         .offset(y:30)
                         .zIndex(1) // Ensures the button is layered above other views
                     
 //                        .padding(.bottom, geometry.safeAreaInsets.bottom)
                         
                         NavigationLink(destination: ReviewPromptView(promptMerger: self.promptMerger).navigationBarBackButtonHidden(true), isActive: $isNavigate) {
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
 }

struct StyleOption: Identifiable, Hashable {
    let id = UUID()
    var name: String
}

struct StyleOptionView: View {
    let option: StyleOption
    @Binding var selectedStyles: Set<String> // Tracks selected styles by name
    
    var isSelected: Bool {
        selectedStyles.contains(option.name)
    }
    
    var body: some View {
        Text(option.name)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .foregroundColor(isSelected ? .white : .black)
            .background(isSelected ? Color.blue : Color.white.opacity(0.3))
            .cornerRadius(13)
            .lineLimit(1)
            .overlay(
                RoundedRectangle(cornerRadius: 13)
                    .stroke(Color.white, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 3, x: 2, y: 2)
            .onTapGesture {
                if isSelected {
                    selectedStyles.remove(option.name)
                } else if selectedStyles.count < 4 {
                    selectedStyles.insert(option.name)
                }
            }
    }
}

struct WrapGridView: View {
    let styleOptions: [StyleOption]
    @Binding var selectedStyles: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(computeRows(), id: \.self) { row in
                HStack {
                    ForEach(row, id: \.id) { option in
                        StyleOptionView(option: option, selectedStyles: $selectedStyles)
                    }
                }
            }
        }
    }
    
    private func computeRows() -> [[StyleOption]] {
        var rows: [[StyleOption]] = [[]]
        var currentRow = 0
        var currentWidth: CGFloat = 0
        
        for option in styleOptions {
            let label = UILabel()
            label.text = option.name
            label.font = .systemFont(ofSize: UIFont.labelFontSize)
            label.sizeToFit()
            let labelWidth = label.frame.size.width + 45 // Adding padding
            
            if currentWidth + labelWidth > UIScreen.main.bounds.width - 25 { // Assuming 15pt of padding on each side
                currentRow += 1
                currentWidth = 0
                rows.append([option])
            } else {
                rows[currentRow].append(option)
            }
            currentWidth += labelWidth
        }
        return rows
    }
}


// Preview for ImageStyleView
struct ImageStyleView_Previews: PreviewProvider {
    static var previews: some View {
        ImageStyleView(promptMerger: PromptMerger())
    }
}
