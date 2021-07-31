//
//  StoppedTimeView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 31.07.2021.
//

import SwiftUI

struct StoppedTimerView: View {
    var body: some View {
        Text("Timer is stopped")
            .font(.title)
            .padding([.bottom], 0)
    }
}

struct StoppedTimerView_Previews: PreviewProvider {
    static var previews: some View {
        StoppedTimerView()
    }
}
