//
//  MonsterWidget.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/11/09.
//

import WidgetKit
import SwiftUI
import FirebaseCore

struct MonsterWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Monster", provider: Provider(monstersRepository: MonstersFirebaseClient(), imageCacheManager: ImageCacheManager())) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName("configurationDisplayName")
        .description("description")
        .supportedFamilies([.systemSmall, .systemMedium])
    }

    init() {
        FirebaseApp.configure()
    }
}

extension MonsterWidget {
    struct Provider: TimelineProvider {
        typealias Entry = MonsterWidget.Entry // swiftlint:disable:this nesting

        private let monstersRepository: MonstersRepository
        private let imageCacheManager: ImageCacheManagerProtocol

        init(monstersRepository: MonstersRepository, imageCacheManager: ImageCacheManagerProtocol) {
            self.monstersRepository = monstersRepository
            self.imageCacheManager = imageCacheManager
        }

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
}

extension MonsterWidget {
    struct Entry: TimelineEntry {
        let date: Date
        let name: String
        let description: String
        let icon: UIImage

        static func createDefault() -> Entry {
            .init(
                date: Date(),
                name: "uhooi",
                description: "ゆかいな　みどりの　せいぶつ。\nわるそうに　みえるが　むがい。",
                icon: UIImage(named: "Uhooi")! // swiftlint:disable:this force_unwrapping
            )
        }
    }
}
