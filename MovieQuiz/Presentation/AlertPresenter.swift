//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Aleksei Frolov on 14.12.23..
//

import UIKit

class AlertPresenter {
    
    static var showAlertViewController: UIViewController?
    
    static func showAlert(model: AlertModel) {
        guard let viewController = showAlertViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }

        alert.addAction(action)

        viewController.present(alert, animated: true, completion: nil)
    }
}
