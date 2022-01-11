import SwiftUI

struct CompositeView: View {
  var composite: Composite
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Text(composite.title)
          .foregroundColor(composite.fontColor)
          .font(.title3)
          .fontWeight(.bold)
          .padding(.horizontal)
          
        Text(composite.subtitle)
          .foregroundColor(composite.fontColor)
          .font(.body)
          .padding(.horizontal)
         
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(composite.miniBottles, id: \.self) { miniBottle in
              MiniBottleView(miniBottle: miniBottle)
            }
          }
          .padding(.horizontal)
        }
        .padding(.top, 25)
        .padding(.bottom, 25)
      }
    }
    .padding(.top)
    .padding(.bottom)
    .background(composite.backgroundColor)
    .cornerRadius(15)
  }
}

struct HomeDetailView_Previews: PreviewProvider {
  static var miniBottle: HomeItem {
    return HomeItem(contentCardData: nil, id: 0, title: "LOREM", eventName: nil, image: nil, imageUrlString: imageUrlString, fontColorString: "#FFFFFF", backgroundColorString: "#000000", compositeID: 0)
  }
  
  static var imageUrlString: String {
    return "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI"
  }
  
  static var previews: some View {
    
    CompositeView(composite: Composite(id: 0, title: "LOREM", subtitle: "IPSUM", fontColorString: "#000000", backgroundColorString: "#FFFFFF", compositeID: 0, miniBottles: [miniBottle, miniBottle, miniBottle, miniBottle]))
  }
}
