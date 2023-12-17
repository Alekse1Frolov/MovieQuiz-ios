//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 10.12.23..
//

import UIKit

struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
    
    init(image: UIImage, question: String, questionNumber: String) {
        self.image = image
        self.question = question
        self.questionNumber = questionNumber
    }
}
