//
//  MonstersFirebaseClient.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import FirebaseFirestore

/// @mockable
public protocol MonstersRepository: AnyObject {
    func loadMonsters() async throws -> [MonsterDTO]
}

public final class MonstersFirebaseClient {

    // MARK: Stored Type Properties

    public static let shared = MonstersFirebaseClient()

    // MARK: Stored Instance Properties

    private let firestore = Firestore.firestore()

    // MARK: Initializers

    private init() {}

}

extension MonstersFirebaseClient: MonstersRepository {

    public func loadMonsters() async throws -> [MonsterDTO] {
        let monstersRef = firestore.collection("monsters")
        let querySnapshot = try await monstersRef.getDocuments()

        var monsters: [MonsterDTO] = []
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

            monsters.append(MonsterDTO(
                name: name,
                description: description,
                baseColorCode: baseColorCode,
                iconUrlString: iconUrlString,
                dancingUrlString: dancingUrlString,
                order: order
            ))
        }

        return monsters
    }
}
