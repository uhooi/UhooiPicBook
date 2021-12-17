//
//  SceneDelegate.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/24.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import CoreSpotlight
import UIKit

@MainActor
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let rootViewController = MonsterListRouter.assembleModule()
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)

        if let userActivity = connectionOptions.userActivities.first {
            executeUserActivity(userActivity)
        }
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

// MARK: - UserActivity

extension SceneDelegate {

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        executeUserActivity(userActivity)
    }

    private func executeUserActivity(_ userActivity: NSUserActivity) {
        switch userActivity.activityType {
        case CSSearchableItemActionType:
            executeSpotlightActivity(userActivity)
        default:
            return
        }
    }

    private func executeSpotlightActivity(_ userActivity: NSUserActivity) {
        guard let key = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
              let monster = UserDefaultsClient().loadMonster(key: key),
              let nav = window?.rootViewController as? UINavigationController else {
            return
        }

        nav.dismiss(animated: false)
        nav.popToRootViewController(animated: false)
        let vc = MonsterDetailRouter.assembleModule(monster: monster)
        nav.pushViewController(vc, animated: true)
    }

}
