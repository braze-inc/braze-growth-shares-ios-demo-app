//
//  Row.swift
//  Braze-Demo
//
//  Created by Justin Malandruccolo on 3/10/21.
//  Copyright © 2021 Justin-Malandruccolo. All rights reserved.
//

import SwiftUI

struct Row: View {
  var summary: Summary
  
  var body: some View {
    VStack {
      HStack {
        Text(summary.header)
          .fontWeight(.semibold)
        Spacer()
      }
      .padding(.bottom, 5)
      HStack {
        Text(summary.body)
          .fontWeight(.light)
        Spacer()
      }
      .padding(.bottom, 5)
      
      
      HStack {
        Text(summary.actionText)
          .fontWeight(.semibold)
        Spacer()
        Text(summary.timeStamp)
          .fontWeight(.light)
      }
    }
    .padding(.leading, 15)
    .padding(.trailing, 15)
    
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
