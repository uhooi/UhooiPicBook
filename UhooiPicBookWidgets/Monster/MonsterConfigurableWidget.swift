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
    typealias Intent = SelectMonsterIntent

    private let imageManager: ImageCacheManagerProtocol

    init(imageManager: ImageCacheManagerProtocol) {
        self.imageManager = imageManager
    }
}

struct MonsterConfigurableWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "SelectMonster",
            intent: SelectMonsterIntent.self,
            provider: MonsterProvider(imageManager: ImageCacheManager())
        ) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName("configurationDisplayName")
        .description("configurableDescription")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

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
        convertDTOToEntry(dto: intent.monster?.convertToDTO()) { entry in
            let entries = [entry ?? .createDefault()]
            completion(Timeline(entries: entries, policy: .never))
        }
    }

    private func convertDTOToEntry(dto: MonsterDTO?, completion: @escaping (Entry?) -> Void) {
        if let dto = dto, let iconUrl = URL(string: dto.iconUrlString) {
            self.imageManager.cacheImage(imageUrl: iconUrl) { result in
                switch result {
                case let .success(icon):
                    let name = dto.name
                    let description = dto.description.replacingOccurrences(of: "\\n", with: "\n")
                    completion(Entry(date: Date(), name: name, description: description, icon: icon))
                case .failure:
                    completion(nil)
            }
        } else {
            completion(nil)
        }
    }
}
