//
//  String+Extension.swift
//  Travio
//
//  Created by Furkan Kızmaz on 6.09.2023.
//

import UIKit

extension String {
    var isValidURL: Bool {
        if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }

    func formatISO8601ToCustomFormat() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFractionalSeconds, .withFullDate, .withFullTime, .withTimeZone]

        if let date = dateFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        }
        return self
    }
}
