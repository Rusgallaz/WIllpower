//
//  EditView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 11.06.2021.
//

import SwiftUI
import CoreData

struct EditView: View {
    @EnvironmentObject var controller: PersistenceController
    @Environment(\.presentationMode) var presentationMode

    @State private var timerName: String
    @State private var startDate: Date

    let timer: WPTimer

    init(timer: WPTimer) {
        self.timer = timer
        _timerName = State(wrappedValue: timer.wrappedName)
        _startDate = State(wrappedValue: timer.wrappedStarDate)

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
        .disabled(timerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Timer name", text: $timerName)
                DatePicker("Start date", selection: $startDate, in: ...Date())
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            .navigationBarTitle(Text("Edit timer"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
        .accentColor(Color.WPActionColor)
    }

    private func save() {
        timer.objectWillChange.send()
        timer.name = timerName
        timer.startDate = startDate
        controller.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        EditView(timer: WPTimer.example(context: contextView))
    }
}
