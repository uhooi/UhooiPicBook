//
//  MonsterWidget.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/11/09.
//

import WidgetKit
import SwiftUI
import FirebaseCore

private struct MonsterProvider {
    typealias Entry = MonsterEntry

    private let monstersRepository: MonstersRepository
    private let imageCacheManager: ImageCacheManagerProtocol

    init(monstersRepository: MonstersRepository, imageCacheManager: ImageCacheManagerProtocol) {
        self.monstersRepository = monstersRepository
        self.imageCacheManager = imageCacheManager
    }
}

struct MonsterWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "Monster",
            provider: MonsterProvider(
                monstersRepository: MonstersFirebaseClient(),
                imageCacheManager: ImageCacheManager()
            )
        ) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName("Configuration display name")
        .description("Description")
        .supportedFamilies([.systemSmall, .systemMedium])
    }

    init() {
        FirebaseApp.configure()
    }
}

extension MonsterProvider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .createDefault()
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.createDefault())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [Entry] = []

        // swiftlint:disable:next closure_body_length
        self.monstersRepository.loadMonsters { result in
            switch result {
            case let .success(monsters):
                let currentDate = Date()
                var hourOffset = 0
                for monster in monsters.sorted(by: { $0.order < $1.order }) {
                    let name = monster.name
                    let description = monster.description.replacingOccurrences(of: "\\n", with: "\n")
                    let iconUrlString = monster.iconUrlString

                    guard let iconUrl = URL(string: iconUrlString) else {
                        continue
                    }

                    let group = DispatchGroup()
                    group.enter()

                    self.imageCacheManager.cacheImage(imageUrl: iconUrl) { result in
                        switch result {
                        case let .success(icon):
                            guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else {
                                fatalError("Fail to unwrap `entryDate`. hourOffset: \(hourOffset), currentDate: \(currentDate)")
                            }
                            let entry = Entry(date: entryDate, name: name, description: description, icon: icon)
                            entries.append(entry)
                            hourOffset += 1
                        case .failure:
                            break
                        }

                        group.leave()
                    }

                    group.wait()
                }
            case .failure:
                break
            }

            completion(Timeline(entries: entries, policy: .atEnd))
        }
    }
}
