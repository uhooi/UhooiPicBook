//
//  MonstersRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import Firebase
import FirebaseStorage

/// @mockable
protocol MonstersRepository: AnyObject {
    func loadMonsters(completion: @escaping (Result<[MonsterDTO], Error>) -> Void)
}

final class MonstersFirebaseClient {
    private let firestore = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
}

extension MonstersFirebaseClient: MonstersRepository {

    func loadMonsters(completion: @escaping (Result<[MonsterDTO], Error>) -> Void) {
        let group = DispatchGroup()
        group.enter()

        var monsters: [MonsterDTO] = []
        var someError: Error?

        let monstersRef = self.firestore.collection("monsters")
        monstersRef.getDocuments { querySnapshot, error in
            if let error = error {
                someError = error
            } else {
                guard let querySnapshot = querySnapshot else {
                    fatalError("Fail to cast `querySnapshot` .")
                }

                for document in querySnapshot.documents.filter({ $0.exists }) {
                    let monster = document.data()
                    guard let name = monster["name"] as? String,
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
            }

            group.leave()
        }

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
