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
            let entry: Entry
            if context.isPreview {
                entry = .createDefault()
            } else {
                // TODO: Firestoreからuhooiのデータを取得する
                entry = .createDefault()
            }
            completion(entry)
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [Entry] = []
            
            let monstersRepository: MonstersRepository = MonstersFirebaseClient()
            monstersRepository.loadMonsters { result in
                switch result {
                case let .success(monsters):
                    let currentDate = Date()
                    var hourOffset = 0
                    monsters
                        .sorted { $0.order < $1.order }
                        .forEach {
                            let name = $0.name
                            let description = $0.description
                            let iconUrlString = $0.iconUrlString
                            
                            guard let iconUrl = URL(string: iconUrlString) else {
                                // TODO: エラーハンドリング
                                return
                            }
                            
                            let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager()
                            imageCacheManager.cacheImage(imageUrl: iconUrl) { result in
                                switch result {
                                case let .success(icon):
                                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                                    let entry = Entry(date: entryDate, name: name, description: description, icon: icon)
                                    entries.append(entry)
                                    hourOffset += 1
                                case let .failure(error):
                                    // TODO: エラーハンドリング
                                    print(error)
                                }
                            }
                        }
                case let .failure(error):
                    // TODO: エラーハンドリング
                    print(error)
                }
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
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

struct MonsterEntryView : View {
    var entry: MonsterWidget.Provider.Entry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                icon
                Spacer(minLength: 8.0)
                name
            }
            .padding()
        case .systemMedium:
            HStack {
                VStack {
                    icon
                    Spacer(minLength: 8.0)
                    name
                }
                Spacer(minLength: 16.0)
                description
            }
            .padding()
        case .systemLarge:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
    
    private var icon: some View {
        Image(uiImage: entry.icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private var name: some View {
        Text(entry.name)
            .font(.headline)
    }
    
    private var description: some View {
        Text(entry.description)
            .font(.body)
    }
}

struct MonsterWidget_Previews: PreviewProvider {
    typealias Entry = MonsterWidget.Entry
    
    static var previews: some View {
        Group {
            MonsterEntryView(entry: .createDefault())
                .redacted(reason: .placeholder)
            MonsterEntryView(entry: .createDefault())
            MonsterEntryView(entry: createShortEntry())
            MonsterEntryView(entry: createLongEntry())
        }
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        Group {
            MonsterEntryView(entry: .createDefault())
                .redacted(reason: .placeholder)
            MonsterEntryView(entry: .createDefault())
            MonsterEntryView(entry: createShortEntry())
            MonsterEntryView(entry: createLongEntry())
        }
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    
    static private func createShortEntry() -> Entry {
        .init(
            date: Date(),
            name: "1",
            description: "1",
            icon: UIImage(named: "Uhooi")!
        )
    }
    
    static private func createLongEntry() -> Entry {
        .init(
            date: Date(),
            name: "123456789012345678901234567890",
            description: "12345678901234567890\n12345678901234567890\n12345678901234567890",
            icon: UIImage(named: "Uhooi")!
        )
    }
}
