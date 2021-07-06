//
//  DetailView.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 09.06.2021.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var passedTime = "0 seconds"
    @State private var isShowingEditActions = false
    @State private var editSelection: String? = nil
    @State private var currentHistory = [WPHistoryDates]()

    @State var timerEvent = Timer.publish(every: 1, tolerance: 0.1, on: .main, in: .common).autoconnect()
    let timer: WPTimer
    
    var body: some View {
        VStack {
            if timer.isActive {
                DetailPassedTimeView(timer: timer)
            } else {
                Text("Timer is stopped")
                    .padding(.top)
                    .font(.title)
            }
            
            Text("History")
                .font(.headline)
                .padding(.top)
            
            ListHistoryView(history: currentHistory)
            
            Spacer()
            NavigationLink(destination: EditView(timer: timer), tag: "Edit", selection: $editSelection) { EmptyView() }
        }
        .onAppear(perform: updateCurrentHistory)
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
        managedObjectContext.delete(timer)
        PersistenceController.shared.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func editTimer() {
        self.editSelection = "Edit"
    }
    
    private func restartTimer() {
        createHistory()
        timer.startDate = Date()
        PersistenceController.shared.save()
        updateCurrentHistory()
    }
    
    private func stopStartTimer() {
        if timer.isActive {
            createHistory()
            timer.isActive = false
        } else {
            timer.startDate = Date()
            timer.isActive = true
        }
        PersistenceController.shared.save()
        updateCurrentHistory()
    }
    
    private func createHistory() {
        let history = WPHistoryDates(context: managedObjectContext)
        history.startDate = timer.startDate
        history.endDate = Date()
        timer.addToHistoryDates(history)
    }
    
    private func updateCurrentHistory() {
        currentHistory = timer.wrappedHistories
    }
}

struct DetailView_Previews: PreviewProvider {
    static let contextView = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    static var previews: some View {
        DetailView(timer:  WPTimer.example(context: contextView))
    }
}
