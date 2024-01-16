//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 15.1.24..
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private let statisticService: StatisticService!
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private weak var viewController: MovieQuizViewController?
    
    private lazy var alertPresenter = AlertPresenter(viewController: viewController)
    
    private var currentQuestion: QuizQuestion?
    
    private let questionsAmount: Int = 10
    
    private var correctAnswers: Int = 0
    
    private var currentQuestionIndex: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController as? MovieQuizViewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartQuiz() -> Void {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func proceedToNextQuestionOrResults() {
        viewController?.answerButtons(isLocked: true)
        viewController?.zeroBorderWidth()
        
        if self.isLastQuestion() {
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: makeResultMessage(),
                buttonText: "Сыграть ещё раз") { [weak self] in
                    self?.restartQuiz()
                }
            
            alertPresenter.showAlert(model: alertModel)
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        viewController?.answerButtons(isLocked: false)
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func makeResultMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = correctAnswers == self.questionsAmount ? "Поздравляем, вы ответили на 10 из 10!" : "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)/\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        let resultMessage = [currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
