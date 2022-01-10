//
//  FirebaseMessagingBridge.swift
//
//
//  Created by uhooi on 2022/01/06.
//

import FirebaseMessaging

public protocol MessagingBridgeDelegate: AnyObject {
    @MainActor func didReceiveRegistrationToken(_ fcmToken: String?)
}

@MainActor
public final class FirebaseMessagingBridge: NSObject {
    public weak var delegate: MessagingBridgeDelegate?

    override public init() {
        super.init()
        Messaging.messaging().delegate = self
    }
}

extension FirebaseMessagingBridge: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        delegate?.didReceiveRegistrationToken(fcmToken)
    }
}
