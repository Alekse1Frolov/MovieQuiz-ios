//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 14.12.23..
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
