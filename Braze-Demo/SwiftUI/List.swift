import SwiftUI

struct List: View {
  let summary = ModelData().summaries[0]
  
  var body: some View {
    ZStack {
      ForEach(0..<5) { _ in
        Row(summary: summary)
      }
    }
    .padding(15)
    .background(Color.gray)
  }
}

struct List_Previews: PreviewProvider {
  static var previews: some View {
    List()
  }
}
