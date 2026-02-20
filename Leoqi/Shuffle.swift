import SwiftUI

struct RandomizerUI {
    static let genderPresentations = ["Feminine","Masculine","Androgynous","Non-binary","Genderqueer","Genderfluid","Agender","Bigender","Gender non-conforming","Two-spirit","Neutrois","Third gender","Transfeminine","Transmasculine","Gender variant","Intergender","Demiboy","Demigirl","Gender creative","Polygender"]
    static let characterTypes = ["Elf Wizard","Human Monk","Dwarf Warrior","Orc Bard","Halfling Rogue","Dragonborn Paladin","Tiefling Sorcerer","Gnome Artificer","Aasimar Cleric","Centaur Ranger","Vampire Assassin","Merfolk Alchemist","Fairy Druid","Goblin Engineer","Minotaur Gladiator","Sphinx Mystic","Android Scientist","Phoenix Summoner","Necromancer Lich","Kitsune Illusionist","Human Detective","Cyborg Soldier","Alien Researcher","Time Traveler","Space Pirate","Mutant Survivor","Robot Mechanic","Superhero Vigilante","Zombie Hunter","Ghost Investigator"]
    static let ageDescriptors = ["Youthful","Aged","Timeless","Middle-aged","Ancient","Eternal","Adolescent","Elderly","Immortal"]

    static let hairDetails = ["Long curly blonde","Short spiky red","Bald","Wavy brown","Straight black","Pixie-cut silver","Thick dreadlocks","Shaved patterns","Flowing auburn locks"]
    static let eyedetails = ["Green-eyed","Blue-eyed","Brown-eyed","Hazel-eyed","Grey-eyed","Amber-eyed","Violet-eyed","Black-eyed","Silver-eyed","Gold-eyed"]

    static let skinTones = ["Pale","Tanned","Dark","Olive","Alabaster","Bronzed","Ebony","Ivory","Rosy"]

    static let bodyShapes = ["Tall and slender","Short and stocky","Muscular","Petite and agile","Broad and bulky","Lean and fit","Plump and soft","Athletic and toned","Lanky and gangly"]

    static let faceShapes = ["Round with freckles","Sharp with high cheekbones","Square with a strong jawline","Oval with delicate features","Heart-shaped with dimples","Long with prominent nose","Diamond with striking eyes","Rectangular with a chiseled chin","Triangular with a pointed chin"]

    static let additionalFeatureExamples = ["Scar across the eye","Tattoos","Piercings","Glowing eyes","Metallic limbs","Horns","Feathered wings","Freckles","Birthmarks"]

    static let garmentTypes = ["Simple green monk tunic","White and gold robe with leaf patterns","Sorcerer's traveling tunic","Sturdy heavy armor","Brown leather armor","Elegant silk gown with intricate embroidery","Roughspun cloak with hidden pockets","Brightly colored jester's outfit with bells","Black thief's garb with reinforced leather","Blue naval uniform with brass buttons","Scarlet duelist's cape with silver trim","Lightweight ranger's cloak with camouflage pattern","Sumptuous velvet dress with pearl adornments","Gladiator's chainmail with bronze helmet","Flowing priestess robe with celestial motifs","Weathered explorer's vest with multiple straps","Shimmering dancer's attire with sequins","Artisan's apron with tool pockets","Assassin's hooded tunic with blade sheaths","Regal coronation robe with gemstone inlays"]

    static let gears = ["Sword","Shield","Bow","Axe","Spear","Dagger","Crossbow","Staff","Wand","Mace","Flail","Halberd","Warhammer","Sling","Blowgun","Net","Trident","Rapier","Scimitar","Whip"]

    static let accessories = ["Ring","Amulet","Belt","Necklace of large mala beads","Bandolier of vials","Bracelet","Cape","Earrings","Gloves","Boots","Cloak","Goggles","Hat","Scarf","Sash","Brooch","Gauntlets","Quiver","Mask","Pendant"]

    static let settings = ["Enchanted forest","Mystical mountain peak","Secluded island","Ancient ruins","Bustling city market","Underground cave","Royal palace","Distant galaxy","Medieval village","Frozen tundra","Desolate desert","High seas","Mysterious swamp","Abandoned castle","Dense jungle","Futuristic metropolis","Haunted mansion","Secret laboratory","Magical academy","Otherworldly dimension"]

    static let actions = ["Juggling colorful balls","Painting a mural","Building a wooden model","Dancing energetically","Cooking a feast","Engaging in combat","Repairing a bicycle","Writing a story","Sketching intently","Training with a master","Performing a ritual","Gardening with care"]

    static let emotions = ["unbridled joy and exuberance"," profound contemplation and introspection"," fierce anger and frustration","overwhelming fear and anxiety","intense concentration and determination","immense surprise and astonishment","profound empathy and compassion","serene peace and contentment","intense curiosity and intrigue"]


    static func randomizeCoreAppearance() -> (gender: String, characterType: String, ageDescriptor: String,hairDetails: String,eyedetails:String, skinTone: String, bodyShape: String, faceShape: String, additionalFeatures: String) {
        return (
            genderPresentations.randomElement() ?? "",
            characterTypes.randomElement() ?? "",
            ageDescriptors.randomElement() ?? "",
            hairDetails.randomElement() ?? "",
            eyedetails.randomElement() ?? "",
            skinTones.randomElement() ?? "",
            bodyShapes.randomElement() ?? "",
            faceShapes.randomElement() ?? "",
            additionalFeatureExamples.randomElement() ?? ""
        )
    }

    static func randomizeClothScen() -> (garmentType: String, gear: String, accessories: String, setting: String, action: String, emotion: String) {
        return (
            garmentTypes.randomElement() ?? "",
            gears.randomElement() ?? "",
            accessories.randomElement() ?? "",
            settings.randomElement() ?? "",
            actions.randomElement() ?? "",
            emotions.randomElement() ?? ""
        )
    }

    static func shuffleCoreAppearance(promptMerger: PromptMerger) {
        let values = randomizeCoreAppearance()
        promptMerger.genderPresentation = values.gender
        promptMerger.charactertype = values.characterType
        promptMerger.ageDescriptor = values.ageDescriptor
        promptMerger.hairdetails = values.hairDetails
        promptMerger.eyedetails = values.eyedetails
        promptMerger.skinTone = values.skinTone
        promptMerger.bodyShape = values.bodyShape
        promptMerger.faceShape = values.faceShape
//        promptMerger.additionalFeatures = values.additionalFeatures
    }

    static func shuffleClothScen(promptMerger: PromptMerger) {
        let values = randomizeClothScen()
        promptMerger.garmentType = values.garmentType
        promptMerger.gear = values.gear
        promptMerger.accessories = values.accessories
        promptMerger.setting = values.setting
        promptMerger.action = values.action
        promptMerger.emotion = values.emotion
    }
}

struct ShuffleDice: View {
    var action: () -> Void
    @State private var isAnimating = false

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isAnimating = true
            }
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isAnimating = false
            }
        }) {
            Image(systemName: "shuffle")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .padding(10)
                .background(isAnimating ? Color.blue : Color.gray)
                .clipShape(Circle())
                .rotationEffect(.degrees(isAnimating ? 90 : 0))
                .scaleEffect(isAnimating ? 1.2 : 1)
                .animation(.easeInOut, value: isAnimating)
        }
    }
}

struct ShuffleDice_Previews: PreviewProvider {
    static var previews: some View {
        ShuffleDice(action: {})
    }
}

