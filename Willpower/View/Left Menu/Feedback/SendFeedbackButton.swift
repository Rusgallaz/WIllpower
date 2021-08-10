//
//  SendFeedbackButton.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 04.08.2021.
//

import SwiftUI

struct SendFeedbackButton: View {
    
    @State private var mailData = ComposeMailData(subject: "Motivation Timers", recipients: ["gallarusaz@gmail.com"])
    @State private var isShowingMailView = false
    
    var body: some View {
        HStack {
            Image(systemName: "envelope.fill")
            Button("Feedback") {
                self.isShowingMailView.toggle()
            }
            .disabled(!MailView.canSendMail)
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.WPActionColor)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(data: $mailData)
        }
    }
}

struct SendFeedbackButton_Previews: PreviewProvider {
    static var previews: some View {
        SendFeedbackButton()
    }
}
