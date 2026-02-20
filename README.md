# Avatar — AI Character Art Generator

iOS app that generates custom AI character artwork using OpenAI's DALL-E 3 API. Users build detailed character prompts through an intuitive UI, then generate unique digital art.

## Features

- **Character Builder** — customize appearance (gender, age, hair, skin, eyes, body, face), clothing, gear, accessories
- **Art Style Selection** — choose from multiple art styles applied to the generated prompt
- **Scene Composer** — set environment, action, and emotion for the character
- **AI Image Generation** — sends composed prompts to DALL-E 3 for 1024x1024 artwork
- **Profile Gallery** — view and manage generated characters

## Tech Stack

- **Swift / SwiftUI** — native iOS app
- **OpenAI API** — DALL-E 3 image generation
- **Unity Ads** — monetization
- **CocoaPods** — dependency management

## Architecture

```
Leoqi/
├── LeoqiApp.swift              # App entry point, Unity Ads init
├── HomeScreenView.swift         # Main landing screen
├── CreationScreenView.swift     # Character creation flow
├── CoreAppearanceView.swift     # Appearance customization UI
├── Clothing&Scenario.swift      # Clothing/scenario selection
├── ImageStyleView.swift         # Art style picker
├── ReviewPromptView.swift       # Preview generated prompt
├── ResultScreenView.swift       # Display generated artwork
├── ProfileViewScreen.swift      # User gallery
├── CharacterPromptGenerator.swift # Prompt composition engine
├── OpenAiService.swift          # OpenAI API integration
├── ViewController.swift         # Unity Ads controller
├── Shuffle.swift                # Randomization utilities
├── SameCompon.swift             # Shared UI components
└── extensions.swift             # Swift extensions
```

## Setup

1. Clone the repo
2. Run `pod install`
3. Open `Leoqi.xcworkspace` in Xcode
4. Set your OpenAI API key as `OPENAI_API_KEY` in the Xcode scheme environment variables
5. Build and run on iOS 16+ simulator or device

## Screenshots

<p float="left">
  <img src="IMG_4405.PNG" width="200" />
  <img src="IMG_4426.jpeg" width="200" />
</p>

## License

MIT
