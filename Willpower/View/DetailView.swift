//
//  DetailView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 09.06.2021.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @EnvironmentObject var controller: PersistenceController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    @State private var isShowingEditActions = false
    @State private var isShowingEditView = false
    @State private var isShowingDeleteTimerAlert = false

    @ObservedObject var timer: WPTimer

    var body: some View {
        VStack {
            Divider()
            DetailPassedTimeView(timer: timer)
            Divider()

            Text("History")
                .font(.headline)
                .padding(.top)

            ListHistoryView(history: timer.wrappedHistories)

            Spacer()
        }
        .navigationBarTitle(timer.wrappedName, displayMode: .inline)
        .navigationBarItems(trailing: settingsButton)
        .actionSheet(isPresented: $isShowingEditActions) {
            ActionSheet(title: Text("Timer settings"), buttons: editButtons)
        }
        .sheet(isPresented: $isShowingEditView) {
            EditView(timer: timer)
        }
        .alert(isPresented: $isShowingDeleteTimerAlert) {
            Alert(title: Text("Delete timer"), message: Text("Are you sure?"),
                  primaryButton: .destructive(Text("Delete"), action: removeTimer), secondaryButton: .cancel())
        }
    }

    private var settingsButton: some View {
        Button(action: showEditActions) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.black)
                .font(.title2)
        }
    }

    private var editButtons: [ActionSheet.Button] {
        var buttons = [
            ActionSheet.Button.default(Text("Edit"), action: editTimer),
            ActionSheet.Button.destructive(Text("Remove"), action: showDeleteAlert),
            ActionSheet.Button.cancel()
        ]
        if timer.isActive {
            buttons.insert(ActionSheet.Button.default(Text("Restart"), action: restartTimer), at: 0)
            buttons.insert(ActionSheet.Button.default(Text("Stop"), action: stopTimer), at: 0)
        } else {
            buttons.insert(ActionSheet.Button.default(Text("Start"), action: startTimer), at: 0)
        }
        return buttons
    }

    private func showEditActions() {
        isShowingEditActions = true
    }

    private func showDeleteAlert() {
        isShowingDeleteTimerAlert = true
    }

    private func removeTimer() {
        controller.delete(timer)
        controller.save()
        presentationMode.wrappedValue.dismiss()
    }

    private func editTimer() {
        self.isShowingEditView = true
    }

    private func restartTimer() {
        stopTimer()
        startTimer()
    }

    private func startTimer() {
        timer.objectWillChange.send()
        timer.startDate = Date()
        timer.isActive = true
        controller.save()
    }

    private func stopTimer() {
        timer.objectWillChange.send()
        createHistory()
        timer.isActive = false
        controller.save()
    }

    private func createHistory() {
        let history = WPHistoryDates(context: managedObjectContext)
        history.startDate = timer.startDate
        history.endDate = Date()
        timer.addToHistoryDates(history)
    }
}

struct DetailView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        DetailView(timer: WPTimer.example(context: contextView))
    }
}
