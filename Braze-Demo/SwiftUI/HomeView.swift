import SwiftUI

struct HomeView: View {
  @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(viewModel.pills, id: \.self) { pill in
              PillView(title: pill.title)
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
              BottleView(title: bottle.title)
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
    .onAppear(perform: viewModel.requestHomeData)
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
