import SwiftUI

struct BottleView: View {
  var title: String
  
  var body: some View {
    ZStack {
      Image(systemName: "bottle")
        .renderingMode(.original)
        .resizable()
        .opacity(0.8)
        .background(Color.black)
      
      VStack {
        Spacer()
        Text(title)
          .foregroundColor(.white)
          .font(.title3)
          .fontWeight(.bold)
          .padding(.vertical)
      }
    }
    .frame(width: 155, height: 255)
    .cornerRadius(15)
  }
}

struct BottleView_Previews: PreviewProvider {
  static var previews: some View {
    BottleView(title: "Bottle")
  }
}
