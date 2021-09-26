//
//  KickOffCoordinator.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 25/9/21.
//

import Foundation
import UIKit

final class KickOffCoordinator:NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let mapToBusinessScenes: MapToBusinessScenes
    
    
    init(navigationController: UINavigationController, mapToBusinessScenes: MapToBusinessScenes) {
        self.navigationController = navigationController
        self.mapToBusinessScenes = mapToBusinessScenes
    }
    
    func start() {
        navigationController.delegate = self
        let mapViewController = self.mapToBusinessScenes.makeMapBussinessSearchController()
        mapViewController.coordinator = self
        self.navigationController.pushViewController(mapViewController, animated: false)
    }
    
    func goToBusinessDetails(id: String) {
        let businessDetailsViewController = self.mapToBusinessScenes.makeBusinessDetailsController()
        let businessDetailsCoordinator = BusinessDetailsCordinator(navigationController: self.navigationController, bussinessDatilsViewController: businessDetailsViewController)
        businessDetailsViewController.businessId = id
        businessDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(businessDetailsCoordinator)
        businessDetailsCoordinator.start()
    }
    
    func childDidFinish(child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let businessDetails = fromViewController as? BusinessDetailsViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(child: businessDetails.coordinator!)
        }
    }
}
