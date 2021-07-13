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
    @State private var passedTime = "0 seconds"
    @State private var isShowingEditActions = false
    @State private var editSelection: String? = nil

    @State var timerEvent = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    @ObservedObject var timer: WPTimer
    
    var body: some View {
        VStack {
            Divider()
            if timer.isActive {
                DetailPassedTimeView(timer: timer)
            } else {
                Text("Timer is stopped")
                    .padding(.top)
                    .font(.title)
            }
            Divider()
            
            Text("History")
                .font(.headline)
                .padding(.top)
            
            ListHistoryView(history: timer.wrappedHistories)
            
            Spacer()
            NavigationLink(destination: EditView(timer: timer), tag: "Edit", selection: $editSelection) { EmptyView() }
        }
        .navigationBarTitle(timer.wrappedName, displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit", action: showEditActions))
        .actionSheet(isPresented: $isShowingEditActions) {
            ActionSheet(title: Text("Timer settings"), buttons: editButtons)
        }
    }
    
    private var editButtons: [ActionSheet.Button] {
        var buttons = [
            ActionSheet.Button.default(Text("Edit"), action: editTimer),
            ActionSheet.Button.default(Text("Remove"), action: removeTimer),
            ActionSheet.Button.default(Text(timer.isActive ? "Stop" : "Start"), action: stopStartTimer),
            ActionSheet.Button.cancel()
        ]
        if timer.isActive {
            buttons.append(ActionSheet.Button.default(Text("Restart"), action: restartTimer))
        }
        return buttons
    }
    
    private func showEditActions() {
        self.isShowingEditActions = true
    }
    
    private func removeTimer() {
        controller.delete(timer)
        controller.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func editTimer() {
        self.editSelection = "Edit"
    }
    
    private func restartTimer() {
        timer.objectWillChange.send()
        createHistory()
        timer.startDate = Date()
        controller.save()
    }
    
    private func stopStartTimer() {
        timer.objectWillChange.send()
        if timer.isActive {
            createHistory()
            timer.isActive = false
        } else {
            timer.startDate = Date()
            timer.isActive = true
        }
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
        DetailView(timer:  WPTimer.example(context: contextView))
    }
}
