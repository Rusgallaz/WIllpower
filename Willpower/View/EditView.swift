//
//  EditView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 11.06.2021.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var timerName = ""
    @State private var startDate = Date()
    
    let timer: WPTimer
    
    var body: some View {
        VStack {
            TextField("Timer name", text: $timerName)
            DatePicker("Start date", selection: $startDate, in: ...Date())
            Button("Save", action: save)
                .padding()
            Spacer()
        }
        .padding()
        .navigationBarTitle("Edit timer", displayMode: .inline)
        .onAppear(perform: firstLoad)
    }
    
    private func save() {
        timer.name = timerName
        timer.startDate = startDate
        PersistenceController.shared.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func firstLoad() {
        timerName = timer.wrappedName
        startDate = timer.wrappedStarDate
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(timer: WPTimer())
    }
}
