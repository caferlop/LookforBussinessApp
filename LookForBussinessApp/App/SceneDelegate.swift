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
    var coordinator: KickOffCoordinator?
    
    private lazy var remoteStore: HTTPClient = {
        GenericHTTPClient(session: URLSession(configuration: .default))
    }()
    
    private lazy var getBusinessUseCase: GetBusinesses = {
        GetBusinesses(restClient: remoteStore)
    }()
    
    private lazy var getBusinessDetailsUseCase: GetBusinessDetail = {
        GetBusinessDetail(restClient: remoteStore)
    }()
    
    private lazy var mapViewBusinessSearchViewController: MapViewBusinessSearchViewController = {
        MapViewBusinessSearchSceneComposer.makeMapViewBusinessSearchViewController(getBusinesses: getBusinessUseCase)
    }()
    
    private lazy var businessDetailsViewController: BusinessDetailsViewController = {
        BusinessDetailSceneComposer.makeBusinessDetailsViewController(getBusinessDetails: getBusinessDetailsUseCase)
    }()
        

    func setUpScene(windowScene: UIWindowScene, window: UIWindow) {
        let navigationController = UINavigationController()
        self.window = window
        coordinator = KickOffCoordinator(navigationController: navigationController, mapViewBusinessesSearch: mapViewBusinessSearchViewController)
        coordinator?.businessDetailsViewController = businessDetailsViewController
        
        coordinator?.start()
        
        
        self.window?.windowScene = windowScene
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        setUpScene(windowScene: windowScene, window: window)
    }

}

