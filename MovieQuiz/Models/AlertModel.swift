//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 14.12.23..
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
    
    init(title: String, message: String, buttonText: String, completion: (() -> Void)?) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.completion = completion
    }
}

