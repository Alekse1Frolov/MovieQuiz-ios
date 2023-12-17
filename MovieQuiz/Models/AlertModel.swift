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
}

