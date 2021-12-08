import SwiftUI

struct BottleView: View {
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
  static var url: URL? {
    return URL(string: "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI")
  }
  
  static var previews: some View {
    BottleView(title: "Bottle", url: url)
  }
}
