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
import Shared

private struct MonsterProvider {
    typealias Entry = MonsterEntry
    typealias Intent = SelectMonsterIntent
}

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

extension MonsterProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .createDefault()
    }

    func getSnapshot(for intent: Intent, in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.createDefault())
    }

    func getTimeline(for intent: Intent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let entry = await convertDTOToEntry(dto: intent.monster?.convertToDTO())
            let entries = [entry ?? .createDefault()]
            completion(Timeline(entries: entries, policy: .never))
        }
    }

    private func convertDTOToEntry(dto: MonsterDTO?) async -> Entry? {
        guard let dto = dto,
              let iconURL = URL(string: dto.iconUrlString),
              let icon = await UIImage.create(url: iconURL)
        else {
            return nil
        }
        let description = dto.description.replacingOccurrences(of: "\\n", with: "\n")
        return Entry(date: Date(), name: dto.name, description: description, icon: icon)
    }
}
