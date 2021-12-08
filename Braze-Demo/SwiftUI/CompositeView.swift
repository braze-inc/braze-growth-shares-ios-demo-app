import SwiftUI

struct CompositeView: View {
  var title: String
  var subtitle: String
  var miniBottles: [MiniBottle]
  
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Text(title)
          .font(.title3)
          .fontWeight(.bold)
          .padding(.horizontal)
          
        Text(subtitle)
          .font(.body)
          .padding(.horizontal)
         
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(miniBottles, id: \.self) { bottle in
              MiniBottleView(title: bottle.title, url: bottle.imageUrl)
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
    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
    .cornerRadius(15)
  }
}

struct HomeDetailView_Previews: PreviewProvider {
  static var imageUrlString: String {
    return "https://i.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI"
  }
  
  static var previews: some View {
    CompositeView(title: "Lorem", subtitle: "Ipsum", miniBottles: [MiniBottle(compositeId: 0, title: "Bottle", imageUrlString: imageUrlString), MiniBottle(compositeId: 0, title: "Bottle", imageUrlString: imageUrlString), MiniBottle(compositeId: 0, title: "Bottle", imageUrlString: imageUrlString), MiniBottle(compositeId: 0, title: "Bottle", imageUrlString: imageUrlString)])
  }
}
