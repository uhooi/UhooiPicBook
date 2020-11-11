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
    init() {
        FirebaseApp.configure()
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Monster", provider: Provider()) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName("configurationDisplayName")
        .description("description")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension MonsterWidget {
    struct Provider: TimelineProvider {
        typealias Entry = MonsterWidget.Entry
        
        func placeholder(in context: Context) -> Entry {
            .createDefault()
        }
        
        func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
            completion(.createDefault())
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [Entry] = []
            
            let monstersRepository: MonstersRepository = MonstersFirebaseClient()
            monstersRepository.loadMonsters { result in
                switch result {
                case let .success(monsters):
                    let currentDate = Date()
                    var hourOffset = 0
                    for monster in monsters.sorted(by: { $0.order < $1.order }) {
                        let name = monster.name
                        let description = monster.description
                        let iconUrlString = monster.iconUrlString
                        
                        guard let iconUrl = URL(string: iconUrlString) else {
                            continue
                        }
                        
                        let imageCacheGroup = DispatchGroup()
                        imageCacheGroup.enter()
                        
                        let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager()
                        imageCacheManager.cacheImage(imageUrl: iconUrl) { result in
                            switch result {
                            case let .success(icon):
                                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                                let entry = Entry(date: entryDate, name: name, description: description, icon: icon)
                                entries.append(entry)
                                hourOffset += 1
                            case .failure(_):
                                break
                            }
                            
                            imageCacheGroup.leave()
                        }
                        
                        imageCacheGroup.wait()
                    }
                case .failure(_):
                    break
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
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
                icon: UIImage(named: "Uhooi")!
            )
        }
    }
}
