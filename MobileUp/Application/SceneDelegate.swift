//
//  SceneDelegate.swift
//  MobileUp
//
//  Created by Artur Bilalov on 12.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene) // создается экземпляр класса UIWindow, описывающий окно, в коотором в дальнейшем будет выводиться интерфейс
        
//         Создание контроллера представления и его XIB файла
        let viewController = WelcomeViewController()
            
//             Создание контроллера навигации
            let navigationController = UINavigationController(rootViewController: viewController)
            
            
        
        let startVC =  navigationController
        
        //let startVC = UINavigationController(rootViewController: WelcomeViewController())
        
        window?.rootViewController = startVC // устанавливаем WelcomeViewController в качестве корневого (стартового) для окна
        
        window?.backgroundColor = .white
        
        window?.makeKeyAndVisible() // окно устанавливается в качестве ключевого и видимого. Ключевое - это значит окно, которе принимает и обрабатывает события касания, т.е. собыития, возникающие из-за касаний пользователя экрана устройства
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

