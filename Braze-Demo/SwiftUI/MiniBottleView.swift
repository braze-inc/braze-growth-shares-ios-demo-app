import SwiftUI

struct MiniBottleView: View {
  var title: String
  var url: URL?
  
  var body: some View {
    ZStack {
      AsyncImage(url: url, content: { image in
        image
          .renderingMode(.original)
          .resizable()
          .opacity(0.8)
      }, placeholder: {
        Color.clear
      })
      
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
  static var url: URL? {
    return URL(string: "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI")
  }
  
    static var previews: some View {
      MiniBottleView(title: "Mini Bottle Grande Bottle Mini Bottle", url: url)
    }
}
