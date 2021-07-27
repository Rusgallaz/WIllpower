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
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Timer name", text: $name)
                
                Toggle("Set custom start date", isOn: $isCustomStartDate.animation())
                
                if isCustomStartDate {
                    DatePicker(selection: $startDate, in: ...Date()) {
                        Text("Start date")
                    }
                    .datePickerStyle(.graphical)
                }
            }
            .navigationBarTitle(Text("New timer"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            }),
                trailing: Button(action: {
                    self.save()
                    self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save").bold()
            }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
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
        controller.save()
        
    }
}

struct AddTimerView_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerView()
    }
}
