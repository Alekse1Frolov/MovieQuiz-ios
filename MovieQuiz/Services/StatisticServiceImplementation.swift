//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 16.12.23..
//

import Foundation

class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue)
            let questions = userDefaults.integer(forKey: Keys.total.rawValue)
            guard questions > 0 else {
                return 0.0
            }
            return Double(correctAnswers) / Double(questions) * 100
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let currentGame = GameRecord(correct: count, total: amount, date: Date())
        if currentGame.correct > bestGame.correct {
            bestGame = currentGame
        }
        gamesCount += 1
        
        let correctAnswers = userDefaults.integer(forKey: Keys.correct.rawValue) + count
        let questions = userDefaults.integer(forKey: Keys.total.rawValue) + amount
                
        userDefaults.set(correctAnswers, forKey: Keys.correct.rawValue)
        userDefaults.set(questions, forKey: Keys.total.rawValue)
    }
}
