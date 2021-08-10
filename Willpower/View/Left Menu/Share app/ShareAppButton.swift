//
//  ShareAppButton.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 09.08.2021.
//

import SwiftUI

struct ShareAppButton: View {
    var body: some View {
        HStack {
            Image(systemName: "arrowshape.turn.up.backward.fill")
            Button("Share", action: actionSheet)
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.WPActionColor)
        }
    }
    
    func actionSheet() {
           guard let urlShare = URL(string: "https://itunes.apple.com/app/id1580215704") else { return }
           let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
       }
}

struct ShareAppButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareAppButton()
    }
}
