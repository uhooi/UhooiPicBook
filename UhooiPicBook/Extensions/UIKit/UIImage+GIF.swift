//
//  UIImage+GIF.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/03/14.
//

import UIKit
import ImageIO

extension UIImage {

    static func gifImage(with url: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: url) else {
            return nil
        }

        return gifImage(data: imageData)
    }

    static func gifImage(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        return animatedImage(with: source)
    }

    // MARK: Private Methods

    private static func animatedImage(with source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images: [CGImage] = []
        var delays: [Int] = []

        (0..<count).forEach {
            if let image = CGImageSourceCreateImageAtIndex(source, $0, nil) {
                images.append(image)
            }
            let delaySeconds = delay(forImageAtIndex: $0, source: source)
            delays.append(Int(delaySeconds * 1000.0))
        }

        let duration = delays.reduce(into: 0) { $0 += $1 }

        let gcd = gcdForArray(delays)

        var frames: [UIImage] = []
        (0..<count).forEach {
            let frame = UIImage(cgImage: images[$0])
            let frameCount = Int(delays[$0] / gcd)
            frames.append(contentsOf: [UIImage](repeating: frame, count: frameCount))
        }

        let animation = animatedImage(with: frames, duration: Double(duration) / 1000.0)

        return animation
    }

    private static func delay(forImageAtIndex index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)

        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                to: AnyObject.self)
        }

        delay = delayObject as! Double // swiftlint:disable:this force_cast

        return delay
    }

    private static func gcdForArray(_ array: [Int]) -> Int {
        guard var gcd = array.first else {
            return 1
        }
        array.forEach { gcd = gcdForPair($0, gcd) }
        return gcd
    }

    // swiftlint:disable:next identifier_name
    private static func gcdForPair(_ a: Int, _ b: Int) -> Int {
        var a = a // swiftlint:disable:this identifier_name
        var b = b // swiftlint:disable:this identifier_name
        if a < b {
            swap(&a, &b)
        }
        while true {
            guard a % b > 0 else {
                return b
            }
            a = b
            b = a % b
        }
    }

}
