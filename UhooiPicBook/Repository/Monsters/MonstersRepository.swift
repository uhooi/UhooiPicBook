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
    func loadMonsters(completion: @escaping (Result<[MonsterDTO], Error>) -> Void)
}

final class MonstersFirebaseClient {
    private let databaseRef = Database.database().reference()
    private let storageRef = Storage.storage().reference()
}

extension MonstersFirebaseClient: MonstersRepository {

    func loadMonsters(completion: @escaping (Result<[MonsterDTO], Error>) -> Void) {
        let group = DispatchGroup()
        group.enter()

        var monsters: [MonsterDTO] = []
        var someError: Error?

        let monstersRef = databaseRef.child("public").child("monsters")
        monstersRef.observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [String: Any]
            for (_, val) in value ?? [:] {
                guard let monster = val as? [String: Any],
                    let name = monster["name"] as? String,
                    let description = monster["description"] as? String,
                    let order = monster["order"] as? Int else {
                        continue
                }

                group.enter()
                self.loadIcon(name: name) { result in
                    switch result {
                    case let .success(icon):
                        monsters.append(MonsterDTO(icon: icon, name: name, description: description, order: order))
                    case let .failure(error):
                        someError = error
                    }
                    group.leave()
                }
            }

            group.leave()
        }, withCancel: { error in
            someError = error
            group.leave()
        })

        group.notify(queue: .global()) {
            completion(someError.map(Result.failure) ?? .success(monsters))
        }
    }

    private func loadIcon(name: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let iconRef = self.storageRef.child("public").child("icons").child("\(name).png")
        iconRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let icon = UIImage(data: data) else {
                fatalError("Fail to load icon.")
            }

            completion(.success(icon))
        }
    }

}
