import SwiftUI

struct HomeView: View {
  @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
  @State private var homeData: HomeData?
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(homeData?.pills ?? [], id: \.self) { pill in
              PillView(title: pill.title, url: pill.imageUrl)
            }
          }
          .padding()
        }
        
        Text("Braze LAB Courses")
          .font(.body)
          .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(viewModel.bottles, id: \.self) { bottle in
              BottleView(title: bottle.title, url: bottle.imageUrl)
            }
          }
          .padding(.horizontal)
          .padding(.bottom)
        }
        
        VStack(spacing: 20) {
          ForEach(viewModel.composites, id: \.self) { composite in
            CompositeView(title: composite.title, subtitle: composite.subtitle, miniBottles: composite.miniBottles)
          }
        }
        .padding(.horizontal)
      }
    }
    .onAppear {
      Task {
        await viewModel.requestHomeData()
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
