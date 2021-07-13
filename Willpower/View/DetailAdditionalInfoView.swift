//
//  DetailAdditionalInfoView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 13.07.2021.
//

import SwiftUI

struct DetailAdditionalInfoView: View {
    
    var body: some View {
        VStack {
            HStack {
                Text("Started date:")
                Spacer()
                Text("01.07.2021, 13:00")
            }
            HStack {
                Text("Total time:")
                Spacer()
                Text("12 days 2 hours")
            }
        }
    }
}

struct DetailAdditionalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAdditionalInfoView()
    }
}
