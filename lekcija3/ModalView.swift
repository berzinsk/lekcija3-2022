//
//  ModalView.swift
//  lekcija3
//
//  Created by karlis.berzins on 09/03/2022.
//

import SwiftUI

struct ModalView: View {
  @Binding var isPresented: Bool

  var body: some View {
    VStack {
      Text("Hello, World!")
        .padding()
      Button("Dismiss") {
        isPresented = false
      }
    }
  }
}
