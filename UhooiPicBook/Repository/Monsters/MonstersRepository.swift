//
//  MonstersRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import Foundation
import FirebaseDatabase

/// @mockable
protocol MonstersRepository: AnyObject {
    func loadMonsters(success: @escaping ([MonsterDTO]) -> Void, failure: @escaping (Error) -> Void)
}

final class MonstersFirebaseClient {
    var ref: DatabaseReference = Database.database().reference()
}

extension MonstersFirebaseClient: MonstersRepository {

    func loadMonsters(success: @escaping ([MonsterDTO]) -> Void, failure: @escaping (Error) -> Void) {
        ref.child("public").child("monsters").observeSingleEvent(of: .value, with: { snapshot in
            var monsters: [MonsterDTO] = []
            let value = snapshot.value as? [String: Any]
            for (_, val) in value ?? [:] {
                guard let monster = val as? [String: Any],
                    let name = monster["name"] as? String,
                    let description = monster["description"] as? String else {
                        continue
                }
                monsters.append(MonsterDTO(iconURL: URL(string: "https://google.com")!, name: name, description: description))
            }
            success(monsters)
        }, withCancel: { error in
            failure(error)
        })
    }

}
