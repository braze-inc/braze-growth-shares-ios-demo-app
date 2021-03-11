import SwiftUI

struct Row: View {
  @State var isSwiped: Bool = false
  var summary: Summary
  
  var drag: some Gesture {
    DragGesture()
      .onChanged {
        if $0.startLocation.x > $0.location.x {
          self.isSwiped = true
      }
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Text(summary.header)
          .fontWeight(.semibold)
        Spacer()
      }
      .padding(5)
      HStack {
        Text(summary.body)
          .fontWeight(.light)
        Spacer()
      }
      .padding(5)
      
      
      HStack {
        Text(summary.actionText)
          .fontWeight(.semibold)
        Spacer()
        Text(summary.timeStamp)
          .fontWeight(.light)
      }
      .padding(5)
    }
    .background(Color.white)
    .gesture(drag)
    .animation(.easeIn)
    .offset(x: isSwiped ? -1000 : 0)
  }
}

struct Row_Previews: PreviewProvider {
  static var summaries = ModelData().summaries
  
  static var previews: some View {
    Group {
      Row(summary: summaries[0])
    }.previewLayout(.fixed(width: 394, height: 150))
  }
}
