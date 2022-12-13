//
//  MonstersRepository.swift
//
//
//  Created by uhooi on 2022/01/16.
//

/// @mockable
public protocol MonstersRepository: AnyObject {
    func monsters() async throws -> [MonsterDTO]
}
