import SwiftUI

struct PillView: View {
  var pill: HomeItem
  
  var body: some View {
    ZStack {
      AsyncImage(url: pill.imageUrl, content: { image in
        image
          .renderingMode(.original)
          .resizable()
          .opacity(0.8)
      }, placeholder: {
        pill.backgroundColor
      })
      
      Text(pill.title)
        .foregroundColor(pill.fontColor)
        .font(.title3)
        .fontWeight(.bold)
    }
    .frame(width: 120, height: 60)
    .cornerRadius(15)
  }
}

struct PillView_Previews: PreviewProvider {
  static var imageUrlString: String {
    return "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI"
  }
  
  static var previews: some View {
    PillView(pill: HomeItem(contentCardData: nil, id: 0, title: "LOREM", eventName: nil, imageUrlString: imageUrlString, fontColorString: "#FFFFFF", backgroundColorString: "#000000", compositeID: nil))
  }
}
