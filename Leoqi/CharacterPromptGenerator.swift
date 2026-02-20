import Combine

class PromptMerger: ObservableObject {
    @Published var genderPresentation: String = ""
    @Published var ageDescriptor: String = ""
    @Published var charactertype: String = ""
    @Published var hairdetails: String = ""
    @Published var skinTone: String = ""
    @Published var eyedetails: String = ""
    //    @Published var cheekType: String = ""
    @Published var bodyShape: String = ""
    @Published var faceShape: String = ""
//    @Published var additionalFeatures: String = ""
    @Published var garmentType: String = ""
    @Published var gear: String = ""
    @Published var accessories: String = ""
    @Published var selectedStyles: Set<String> = [] // Holds style names
    @Published var setting: String = ""
    @Published var action: String = ""
    @Published var emotion: String = ""
    
    func generatePrompt() -> String {
        // Initialize promptComponents at the start of the function
        var promptComponents: [String] = []
        
        // Building the appearance description
        var appearanceComponents: [String] = []
        if !genderPresentation.isEmpty { appearanceComponents.append(genderPresentation.lowercased()) }
        if !ageDescriptor.isEmpty { appearanceComponents.append(ageDescriptor.lowercased()) }
        if !charactertype.isEmpty { appearanceComponents.append(charactertype.lowercased()) }
        if !hairdetails.isEmpty { appearanceComponents.append("\(hairdetails.lowercased()) hair") }
        if !skinTone.isEmpty { appearanceComponents.append("\(skinTone.lowercased()) skin") }
        if !eyedetails.isEmpty { appearanceComponents.append(eyedetails.lowercased()) }
        if !bodyShape.isEmpty { appearanceComponents.append(bodyShape.lowercased()) }
        if !faceShape.isEmpty { appearanceComponents.append(faceShape.lowercased()) }
//        if !additionalFeatures.isEmpty { appearanceComponents.append(additionalFeatures.lowercased()) }
        
        let appearance = appearanceComponents.joined(separator: ", ")
        if !appearance.isEmpty { promptComponents.append(appearance) }
        
        // Building the clothing description
        var clothingComponents: [String] = []
        if !garmentType.isEmpty { clothingComponents.append(garmentType.lowercased()) }
        if !gear.isEmpty { clothingComponents.append("carrying \(gear.lowercased())") }
        if !accessories.isEmpty { clothingComponents.append("and \(accessories.lowercased())") }
        
        let clothing = clothingComponents.joined(separator: ", ")
        if !clothing.isEmpty { promptComponents.append("They are wearing \(clothing)") }
        
        // Building the style description
        let styles = selectedStyles.joined(separator: ", ")
        // Append styles to promptComponents if not empty
        if !styles.isEmpty { promptComponents.append("The artwork features \(styles.lowercased())") }
        
        // Building the scenario description
        var scenarioComponents: [String] = []
        if !setting.isEmpty { scenarioComponents.append("They are in a \(setting.lowercased())")}
        if !action.isEmpty { scenarioComponents.append(action.lowercased()) }
        if !emotion.isEmpty { scenarioComponents.append("their expression showing \(emotion.lowercased())")}
        
        let scenario = scenarioComponents.joined(separator: ", ")
        if !scenario.isEmpty { promptComponents.append(scenario)}
        
        // Constructing the final prompt
        let prompt = promptComponents.isEmpty ? "" : "A digital painting of a \(promptComponents.joined(separator: "."))."
        return prompt
    }
}
