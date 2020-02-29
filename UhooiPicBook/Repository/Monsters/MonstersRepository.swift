//
//  MonstersRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import FirebaseDatabase
import FirebaseStorage

/// @mockable
protocol MonstersRepository: AnyObject {
    func loadMonsters(success: @escaping ([MonsterDTO]) -> Void, failure: @escaping (Error) -> Void)
}

final class MonstersFirebaseClient {
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
}

extension MonstersFirebaseClient: MonstersRepository {

    func loadMonsters(success: @escaping ([MonsterDTO]) -> Void, failure: @escaping (Error) -> Void) {
        let monstersRef = databaseRef.child("public").child("monsters")
        monstersRef.observeSingleEvent(of: .value, with: { snapshot in
            var monsters: [MonsterDTO] = []
            let value = snapshot.value as? [String: Any]
            for (_, val) in value ?? [:] {
                guard let monster = val as? [String: Any],
                    let name = monster["name"] as? String,
                    let description = monster["description"] as? String else {
                        continue
                }

                self.loadIcon(name: name, success: { icon in
                    monsters.append(MonsterDTO(icon: icon, name: name, description: description))
                }, failure: { error in
                    failure(error)
                    return
                })
            }
            success(monsters)
        }, withCancel: { error in
            failure(error)
        })
    }

    private func loadIcon(name: String, success: @escaping (UIImage) -> Void, failure: @escaping (Error) -> Void) {
        let iconRef = self.storageRef.child("public").child("icons").child("\(name).png")
        iconRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                failure(error)
                return
            }

            guard let data = data, let icon = UIImage(data: data) else {
                fatalError("Fail to load icon.")
            }

            success(icon)
            return
        }
    }

}
