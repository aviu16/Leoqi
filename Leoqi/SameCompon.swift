//import SwiftUI
//
//// MARK: CustomBackButton
//struct CustomBackButton: View {
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            ZStack {
//                Ellipse()
//                    .fill(Color.gray)
//                    .frame(width: 36, height: 36)
//                Image(systemName: "chevron.left")
//                    .font(.title)
//                    .foregroundColor(.white)
//            }
//            .offset(x: -12, y: -5)
//            .padding(.leading)
//        }
//    }
//}
//
//// MARK: StepTitle
//struct StepTitle: View {
//    let stepNumber: String
//    let title: String
//
//    var body: some View {
//        VStack {
//            Text("Step \(stepNumber)")
//                .font(Font.custom("Inter", size: 24).weight(.heavy))
//                .foregroundColor(.white)
//                .frame(width: 182, height: 10)
//                .offset(x: -20, y: 40)
//            Text(title)
//                .font(Font.custom("Inter", size: 20).weight(.heavy))
//                .foregroundColor(.white.opacity(0.87))
//                .offset(x: -140, y: 90)
//                .frame(width: 212, height: 44)
//        }
//    }
//}
//
//// MARK: NextButton
//struct NextButton: View {
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Text("Next")
//                .font(Font.custom("Inter", size: 18).weight(.heavy))
//                .foregroundColor(.white)
//        }
//        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
//        .frame(width: 176, height: 50)
//        .background(Color.black.opacity(0.20))
//        .cornerRadius(50)
//        .overlay(
//            RoundedRectangle(cornerRadius: 50)
//                .stroke(Color.white, lineWidth: 2)
//        )
//        .offset(y: -90) // Adjust the offset as needed
//        .padding(.bottom)
//    }
//}
//
//struct SpiralImage: View {
//    var body: some View {
//        Image("spiral")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 102.61, height: 102)
//            .background(Color.black.opacity(0)) // Adjust as needed
//    }
//}
