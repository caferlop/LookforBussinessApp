//
//  Coordinator.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 22/9/21.
//

import Foundation
import UIKit
import LookForBussiness

protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
    func showAlerWithTitle(title: String, message: String)
}

extension Coordinator {
    func showAlerWithTitle(title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController.popViewController(animated: false)
        }))
        self.navigationController.present(alert, animated: true, completion:nil)
    }
}

