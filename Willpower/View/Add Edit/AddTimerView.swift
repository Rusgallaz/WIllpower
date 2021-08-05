//
//  AddTimerView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 07.06.2021.
//

import SwiftUI

struct AddTimerView: View {
    @EnvironmentObject var controller: PersistenceController
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @State private var name = ""
    @State private var startDate = Date()
    @State private var isCustomStartDate = false

    init() {
        UINavigationBar.appearance().backgroundColor = .white
    }

    private var cancelButton: some View {
        Button("Cancel") {
            self.presentationMode.wrappedValue.dismiss()
        }
    }

    private var saveButton: some View {
        Button(action: save) {
            Text("Save").bold()
        }
        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField(LocalizedStringKey("Timer name"), text: $name)

                Toggle("Set custom start date", isOn: $isCustomStartDate.animation())
                if isCustomStartDate {
                    DatePicker(selection: $startDate, in: ...Date()) {
                        Text("Start date")
                    }
                    .datePickerStyle(.graphical)
                }
            }
            .navigationBarTitle(Text("New timer"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
        .accentColor(Color.WPActionColor)
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
        controller.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerView()
    }
}
