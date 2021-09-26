//
//  BusinessDetailsCoordinator.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 25/9/21.
//

import Foundation
import UIKit


final class BusinessDetailsCordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: KickOffCoordinator?
    
    var navigationController: UINavigationController
    private weak var bussinessDatilsViewController: BusinessDetailsViewController?
    
    init(navigationController: UINavigationController, bussinessDatilsViewController: BusinessDetailsViewController) {
        self.navigationController = navigationController
        self.bussinessDatilsViewController = bussinessDatilsViewController
        
    }
    
    func start() {
        self.bussinessDatilsViewController?.coordinator = self
        navigationController.pushViewController(self.bussinessDatilsViewController!, animated: false)
    }
    
}
