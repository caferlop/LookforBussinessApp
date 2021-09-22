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
}

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    let getBusinessUseCase: GetBusinesses
    let getBusinessDetailsUseCase: GetBusinessDetail

    init(navigationController: UINavigationController, getBusinessUseCase: GetBusinesses, getBusinessDetailsUseCase: GetBusinessDetail) {
        self.navigationController = navigationController
        self.getBusinessUseCase = getBusinessUseCase
        self.getBusinessDetailsUseCase = getBusinessDetailsUseCase
    }

    func start() {
        let initialViewController = MapViewBusinessSearchSceneComposer.makeMapViewBusinessSearchViewController(getBusinesses: self.getBusinessUseCase, coordinator: self)
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func getBusinessDetails(id: String) {
        let businessDetailsController = BusinessDetailSceneComposer.makeBusinessDetailsViewController(id: id, getBusinessDetails: self.getBusinessDetailsUseCase, coordinator: self)
        navigationController.pushViewController(businessDetailsController, animated: false)
    }
    
    func showAlerWithTitle(title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController.popViewController(animated: false)
        }))
        self.navigationController.present(alert, animated: true, completion:nil)
    }
}
