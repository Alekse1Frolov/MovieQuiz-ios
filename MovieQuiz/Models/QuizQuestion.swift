//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 10.12.23..
//

import Foundation

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
    
    init(image: String, text: String, correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
}
