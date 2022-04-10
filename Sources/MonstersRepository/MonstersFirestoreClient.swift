//
//  MonstersFirestoreClient.swift
//  UhooiPicBook
//
//  Created by uhooi on 2020/02/28.
//

import FirebaseFirestore

public final class MonstersFirestoreClient {

    // MARK: Stored Instance Properties

    private let firestore = Firestore.firestore()

    // MARK: Initializers

    private init() {}
}

extension MonstersFirestoreClient: MonstersRepository {
    public static let shared = MonstersFirestoreClient()

    public func monsters() async throws -> [MonsterDTO] {
        let monstersRef = firestore.collection("monsters")
        let querySnapshot = try await monstersRef.getDocuments()

        var monsters: [MonsterDTO] = []
        for document in querySnapshot.documents.filter({ $0.exists }) {
            let monster = document.data()
            guard let name = monster["name"] as? String,
                  let description = monster["description"] as? String,
                  let baseColorCode = monster["base_color"] as? String,
                  let iconURLString = monster["icon_url"] as? String,
                  let dancingURLString = monster["dancing_url"] as? String,
                  let order = monster["order"] as? Int else {
                continue
            }

            monsters.append(MonsterDTO(
                name: name,
                description: description,
                baseColorCode: baseColorCode,
                iconURLString: iconURLString,
                dancingURLString: dancingURLString,
                order: order
            ))
        }

        return monsters
    }
}
