//
//  MonstersRepository.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import Firebase

/// @mockable
protocol MonstersRepository: AnyObject { // swiftlint:disable:this file_types_order
    func loadMonsters(_ completion: @escaping (Result<[MonsterDTO], Error>) -> Void)
}

final class MonstersFirebaseClient {
    private let firestore = Firestore.firestore()
}

extension MonstersFirebaseClient: MonstersRepository {

    func loadMonsters(_ completion: @escaping (Result<[MonsterDTO], Error>) -> Void) {
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
                          let baseColorCode = monster["base_color"] as? String,
                          let iconUrlString = monster["icon_url"] as? String,
                          let dancingUrlString = monster["dancing_url"] as? String,
                          let order = monster["order"] as? Int else {
                        continue
                    }

                    monsters.append(MonsterDTO(name: name, description: description, baseColorCode: baseColorCode, iconUrlString: iconUrlString, dancingUrlString: dancingUrlString, order: order))
                }
            }

            completion(someError.map(Result.failure) ?? .success(monsters))
        }
    }

}
