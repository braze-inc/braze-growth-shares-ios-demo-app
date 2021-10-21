import SwiftUI

struct CompositeView: View {
  var title: String
  var subtitle: String
  var miniBottles: [Bottle]
  
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
              MiniBottleView(title: bottle.title)
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
  static var previews: some View {
    CompositeView(title: "Lorem", subtitle: "Ipsum", miniBottles: [Bottle(title: "Bottle"), Bottle(title: "Bottle"), Bottle(title: "Bottle"), Bottle(title: "Bottle")])
  }
}
