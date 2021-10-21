import SwiftUI

struct MiniBottleView: View {
  var title: String
  
  var body: some View {
    ZStack {
      Image(systemName: "bottle")
        .renderingMode(.original)
        .resizable()
        .opacity(0.8)
        .background(Color.black)
      
      VStack {
        Text(title)
          .foregroundColor(.white)
          .font(.body)
          .fontWeight(.bold)
          .multilineTextAlignment(.center)
          .padding()
      }
    }
    .frame(width: 150, height: 200)
    .cornerRadius(15)
  }
}

struct MiniBottleView_Previews: PreviewProvider {
    static var previews: some View {
        MiniBottleView(title: "Mini Bottle Grande Bottle Mini Bottle")
    }
}
