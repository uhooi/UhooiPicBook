// swiftlint:disable:this file_name
//
//  UncheckedSendable.swift
//  UhooiPicBook
//
//  Created by uhooi on 2021/12/16.
//

import UIKit

extension URL: @unchecked Sendable {}
extension IndexPath: @unchecked Sendable {}
extension UIImage: @unchecked Sendable {}
extension UIColor: @unchecked Sendable {}
