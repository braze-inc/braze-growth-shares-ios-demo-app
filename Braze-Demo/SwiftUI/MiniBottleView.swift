import SwiftUI

struct MiniBottleView: View {
  var body: some View {
    ZStack {
      Image(systemName: "bottle")
        .renderingMode(.original)
        .resizable()
        .opacity(0.8)
        .background(Color.black)
      
      VStack {
        Text("Mini Bottle")
          .foregroundColor(.white)
          .font(.body)
          .fontWeight(.bold)
          .padding(.vertical)
      }
    }
    .frame(width: 150, height: 200)
    .cornerRadius(15)
  }
}

struct MiniBottleView_Previews: PreviewProvider {
    static var previews: some View {
        MiniBottleView()
    }
}
