//
//  SceneDelegate.swift
//  LookForBussinessApp
//
//  Created by carlos fernandez on 20/9/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func setUpScene() {
        //window?.rootViewController = UINavigationController(rootViewController: MapViewBusinessSearchViewController())
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        setUpScene()
    }

}

