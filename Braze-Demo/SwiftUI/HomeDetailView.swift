import SwiftUI

struct HomeDetailView: View {
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Text("Lorem Ipsum")
          .font(.title3)
          .fontWeight(.bold)
          
        Text("Lorem Ipsum")
          .font(.body)
         
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            MiniBottleView()
            MiniBottleView()
            MiniBottleView()
          }
        }
        .padding(.top, 25)
        .padding(.bottom, 25)
      }
    }
    .padding(.top)
    .padding(.bottom)
    .padding(.leading)
    .background(Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255))
    .cornerRadius(15)
  }
}

struct HomeDetailView_Previews: PreviewProvider {
  static var previews: some View {
    HomeDetailView()
  }
}
