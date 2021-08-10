//
//  RateAppButton.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 09.08.2021.
//

import SwiftUI

struct RateAppButton: View {
    var body: some View {
        HStack {
            Image(systemName: "star.fill")
            Button("Rate App", action: openAppStoreReview)
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.WPActionColor)
        }
    }
    
    func openAppStoreReview() {
        let appId = "1580215704"
        let url = "itms-apps://itunes.apple.com/app/id\(appId)?mt=8&action=write-review"

        guard let url = URL(string: url) else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct RateAppButton_Previews: PreviewProvider {
    static var previews: some View {
        RateAppButton()
    }
}
