//
//  MonsterConfigurableWidget.swift
//  UhooiPicBookWidgets
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import WidgetKit
import SwiftUI
import Intents

// TODO: `MonsterWidget` のプロバイダーもこの実装に合わせる
private struct MonsterProvider {
    typealias Entry = MonsterWidget.Entry // TODO: `Entry` を `MonsterWidget` から独立させる
    typealias Intent = ConfigurationIntent

    private let imageManager: ImageCacheManagerProtocol

    init(imageManager: ImageCacheManagerProtocol) {
        self.imageManager = imageManager
    }
}

// MARK: - Main Type
struct MonsterConfigurableWidget: Widget {
    static var kind: String { .init(describing: self) }

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: Self.kind,
            intent: ConfigurationIntent.self,
            provider: MonsterProvider(imageManager: ImageCacheManager()),
            content: MonsterEntryView.init
        )
        .configurationDisplayName("configurationDisplayName")
        .description("configurableDescription")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - IntentTimelineProvider
extension MonsterProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .createDefault()
    }

    func getSnapshot(for intent: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        getEntry(monster: intent.monster?.convertToDTO()) { entry in
            completion(entry ?? placeholder(in: context))
        }
    }

    func getTimeline(for intent: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        getEntry(monster: intent.monster?.convertToDTO()) { entry in
            let entries = [entry ?? placeholder(in: context)]
            completion(Timeline(entries: entries, policy: .never))
        }
    }

    private func getEntry(monster: MonsterDTO?, completion: @escaping (Entry?) -> Void) {
        if let monster = monster, let url = URL(string: monster.iconUrlString) {
            imageManager.cacheImage(imageUrl: url) { result in
                let result = result.map { icon -> Entry in
                    let name = monster.name
                    let description = monster.description.replacingOccurrences(of: "\\n", with: "\n")
                    return Entry(date: Date(), name: name, description: description, icon: icon)
                }
                completion(try? result.get())
            }
        } else {
            completion(nil)
        }
    }
}
