import SwiftUI

struct PillView: View {
  var title: String
  
  var body: some View {
    ZStack {
      Image(systemName: "pill")
        .renderingMode(.original)
        .resizable()
        .opacity(0.8)
        .background(Color.black)
      Text(title)
        .foregroundColor(.white)
        .font(.title3)
        .fontWeight(.bold)
    }
    .frame(width: 120, height: 60)
    .cornerRadius(15)
  }
}

struct PillView_Previews: PreviewProvider {
  static var previews: some View {
    PillView(title: "PILL")
  }
}
