//
//  MenuView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 02.08.2021.
//

import SwiftUI

struct MenuView: View {
    
    @Binding var isOpen: Bool
    
    @State private var offset = CGSize.zero
    
    private let width = UIScreen.main.bounds.width * 0.8
    
    var body: some View {
        let swipeMenuGesture = DragGesture()
            .onChanged { gesture in
                if gesture.translation.width > 0 { return }
                self.offset = gesture.translation
            }
            .onEnded { _ in
                withAnimation {
                    if self.offset.width < -50 {
                        self.offset = .zero
                        self.isOpen = false
                    } else {
                        self.offset = .zero
                    }
                }
            }

        ZStack(alignment: .leading) {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(self.isOpen ? 0.5 : 0)
                .onTapGesture {
                    withAnimation {
                        self.isOpen = false
                    }
                }
            
            MenuItemsView()
                .padding()
                .frame(width: width, alignment: .leading)
                .background(Color.WPBackground.edgesIgnoringSafeArea(.all))
                .offset(x: self.isOpen ? offset.width : -width)
        }
        .gesture(swipeMenuGesture)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isOpen: .constant(true))
    }
}
