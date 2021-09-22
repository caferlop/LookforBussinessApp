//
//  SceneDelegate.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 20/9/21.
//

import UIKit
import LookForBussiness

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    private lazy var remoteStore: HTTPClient = {
        GenericHTTPClient(session: URLSession(configuration: .default))
    }()
    
    private lazy var getBusinessUseCase: GetBusinesses = {
        GetBusinesses(restClient: remoteStore)
    }()
    
    private lazy var getBusinessDetailsUseCase: GetBusinessDetail = {
        GetBusinessDetail(restClient: remoteStore)
    }()

    func setUpScene(windowScene: UIWindowScene, window: UIWindow) {
        let navigationController = UINavigationController()
        
        coordinator = MainCoordinator(navigationController: navigationController, getBusinessUseCase: self.getBusinessUseCase, getBusinessDetailsUseCase: self.getBusinessDetailsUseCase)
        coordinator?.start()
        
        window.windowScene = windowScene
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        setUpScene(windowScene: windowScene, window: window)
    }

}

