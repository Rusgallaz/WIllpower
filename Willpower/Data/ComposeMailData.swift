//
//  ComposeMailData.swift
//  Willpower
//
//  Created by Ruslan Gallyamov on 04.08.2021.
//

import Foundation

/// A model for sending emails. Contains a subject and recipients.
struct ComposeMailData {
    let subject: String
    let recipients: [String]
}
