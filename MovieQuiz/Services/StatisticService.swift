//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 16.12.23..
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
