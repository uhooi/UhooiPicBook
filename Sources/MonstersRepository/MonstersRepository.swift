//
//  MonstersRepository.swift
//
//
//  Created by uhooi on 2022/01/16.
//

/// @mockable
public protocol MonstersRepository: AnyObject {
    static var shared: Self { get }
    func monsters() async throws -> [MonsterDTO]
}
