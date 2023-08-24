//
//  MonsterConfigurableWidget.swift
//  UhooiPicBookWidgets
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import WidgetKit
import SwiftUI
import MonsterWidgets
import MonstersRepository
import ImageLoader

// MARK: MonsterConfigurableWidget

struct MonsterConfigurableWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "MonsterConfigurable",
            intent: SelectMonsterIntent.self,
            provider: MonsterProvider()
        ) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName(R.LocalizedString.configurationDisplayName)
        .description(R.LocalizedString.configurableDescription)
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - MonsterProvider

private struct MonsterProvider {
    typealias Entry = MonsterEntry
    typealias Intent = SelectMonsterIntent
}

extension MonsterProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .placeholder()
    }

    func getSnapshot(for intent: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.placeholder())
    }

    func getTimeline(for intent: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let entry = await entry(dto: intent.monster?.dto())
            let entries = [entry ?? .placeholder()]
            completion(Timeline(entries: entries, policy: .never))
        }
    }

    private func entry(dto: MonsterDTO?) async -> Entry? {
        guard let dto,
              let iconURL = URL(string: dto.iconURLString),
              let icon = await UIImage.create(with: iconURL)
        else {
            return nil
        }
        let description = dto.description.replacingOccurrences(of: "\\n", with: "\n")
        return Entry(date: .now, name: dto.name, description: description, icon: icon)
    }
}
