//
//  MenuItemsView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 03.08.2021.
//

import SwiftUI

struct MenuItemsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Discipline Timers")
                .font(.title2)
            Divider()

            SendFeedbackButton()
                .padding(.top)
//            HStack {
//                Image(systemName: "arrowshape.turn.up.backward.fill")
//                Button("Share") { }.buttonStyle(PlainButtonStyle())
//            }
//            HStack {
//                Image(systemName: "star.fill")
//                Button("Rate App") { }.buttonStyle(PlainButtonStyle())
//            }
            Spacer()

            Divider()
            Text("Version: 1.0")
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
}

struct MenuItemsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemsView()
    }
}
