import SwiftUI

struct MiniBottleView: View {
  var miniBottle: HomeItem
  
  var body: some View {
    ZStack {
      AsyncImage(url: miniBottle.imageUrl, content: { image in
        image
          .renderingMode(.original)
          .resizable()
          .opacity(0.8)
      }, placeholder: {
        miniBottle.backgroundColor
      })
      
      VStack {
        Text(miniBottle.title)
          .foregroundColor(miniBottle.fontColor)
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
  static var imageUrlString: String {
    "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI"
  }
  
    static var previews: some View {
      MiniBottleView(miniBottle: HomeItem(contentCardData: nil, id: 0, title: "LOREM", eventName: nil, image: nil, imageUrlString: imageUrlString, fontColorString: "#FFFFFF", backgroundColorString: "#000000", compositeID: 0))
    }
}
