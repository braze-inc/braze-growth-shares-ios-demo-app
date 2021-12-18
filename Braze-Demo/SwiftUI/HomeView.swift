import SwiftUI

struct HomeView: View {
  @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(viewModel.pills, id: \.self) { pill in
              PillView(pill: pill)
            }
          }
          .padding()
        }
        
        Text(viewModel.header.title)
          .foregroundColor(viewModel.header.fontColor)
          .font(.body)
          .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(viewModel.bottles, id: \.self) { bottle in
              BottleView(bottle: bottle)
            }
          }
          .padding(.horizontal)
          .padding(.bottom)
        }
        
        VStack(spacing: 20) {
          ForEach(viewModel.composites, id: \.self) { composite in
            CompositeView(composite: composite)
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
