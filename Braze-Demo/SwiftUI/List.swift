import SwiftUI

struct List: View {
  @State var isReset = false
  let summary = ModelData().summaries[0]
  
  var body: some View {
    VStack {
      ZStack {
        VStack {
          VStack {
            Text("That's all for now!")
              .padding(.vertical, 2.5)
            Text("Content Cards will be appear here as they become available.")
          }
          .multilineTextAlignment(.center)
          .foregroundColor(Color.black)
          .padding(.horizontal, 25)
          
          Button("Start Over") {
            isReset = true
          }
          .font(Font.title2.weight(.semibold))
          .padding()
          .foregroundColor(Color.green)
        }
        
        ForEach(0..<5) { _ in
          Row(isReset: $isReset, summary: summary)
        }
      }
      .padding(15)
      
      Spacer()
    }
    .background(Color(UIColor.systemGray5))
  }
}

struct List_Previews: PreviewProvider {
  static var previews: some View {
    List()
  }
}
