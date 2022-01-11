import SwiftUI

struct BottleView: View {
  var bottle: HomeItem
  
  var body: some View {
    ZStack {
      AsyncImage(url: bottle.imageUrl, content: { image in
        image
          .renderingMode(.original)
          .resizable()
          .opacity(0.8)
      }, placeholder: {
        bottle.backgroundColor
      })
      
      VStack {
        Spacer()
        Text(bottle.title)
          .foregroundColor(bottle.fontColor)
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
  static var imageUrlString: String {
    return "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI"
  }
  
  static var previews: some View {
    BottleView(bottle: HomeItem(contentCardData: nil, id: 0, title: "LOREM", eventName: nil, image: nil, imageUrlString: imageUrlString, fontColorString: "#FFFFFF", backgroundColorString: nil, compositeID: nil))
  }
}
