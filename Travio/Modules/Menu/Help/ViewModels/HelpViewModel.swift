//
//  HelpViewModel.swift
//  Travio
//
//  Created by Furkan Kızmaz on 11.09.2023.
//

import Foundation

class HelpViewModel {
    let faqItems: [FAQItem]

    init() {
        self.faqItems = [
            FAQItem(question: "How can I create a new account on Travio?", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
            FAQItem(question: "How can I save a visit?", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."),
            FAQItem(question: "How does Travio work?", answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
        ]
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        return faqItems.count
    }

    func item(at indexPath: IndexPath) -> FAQItem? {
        guard indexPath.row < faqItems.count else {
            return nil
        }
        return faqItems[indexPath.row]
    }
}
