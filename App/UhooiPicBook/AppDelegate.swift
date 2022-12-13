//
//  AppDelegate.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/24.
//  Copyright © 2020 THE Uhooi. All rights reserved.
//

import UIKit
import FirebaseSetup
import FirebaseMessagingBridge

@UIApplicationMain
@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let firebaseMessagingBridge = FirebaseMessagingBridge()

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseSetup.configure()
        configureNotifications(application: application)
        firebaseMessagingBridge.delegate = self

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Other Private Methods

    private func configureNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { _, _ in }

        application.registerForRemoteNotifications()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let urlString = userInfo["url"] as? String {
            open(urlString)
        }
        completionHandler()
    }

    private func open(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            assertionFailure("Fail to initialize URL.")
            return
        }
        UIApplication.shared.open(url)
    }
}

extension AppDelegate: MessagingBridgeDelegate {
    func didReceiveRegistrationToken(_ fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
