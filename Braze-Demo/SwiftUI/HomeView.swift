import SwiftUI

struct HomeView: View {
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            PillView()              
            PillView()
            PillView()
          }
          .padding()
        }
        
        Text("Lorem Ipsum")
          .font(.body)
          .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            BottleView()
            BottleView()
            BottleView()
          }
          .padding(.horizontal)
          .padding(.bottom)
        }
        
        VStack(spacing: 20) {
          HomeDetailView()
          HomeDetailView()
          HomeDetailView()
        }
        .padding(.horizontal)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
