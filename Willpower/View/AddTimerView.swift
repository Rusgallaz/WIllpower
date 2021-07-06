//
//  AddTimerView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 07.06.2021.
//

import SwiftUI

struct AddTimerView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name = ""
    @State private var startDate = Date()
    @State private var isCustomStartDate = false
    
    var body: some View {
        Form {
            Section {
                TextField("Timer name", text: $name)

                Toggle("Set custom start date", isOn: $isCustomStartDate)
                
                if isCustomStartDate {
                    DatePicker(selection: $startDate, in: ...Date()) {
                        Text("Start date")
                    }
                }
            }
            
            Button("Create") {
                save()
                self.presentationMode.wrappedValue.dismiss()
            }
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

        }
    }
    
    private func save() {
        let timer = WPTimer(context: managedObjectContext)
        timer.name = self.name
        if isCustomStartDate {
            timer.startDate = self.startDate
        } else {
            timer.startDate = Date()
        }
        timer.isActive = true
        PersistenceController.shared.save()
    }
}

struct AddTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerView()
    }
}
