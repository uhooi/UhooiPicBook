//
//  MonsterConfigurableWidget.swift
//  UhooiPicBookWidgets
//
//  Created by Takehito Koshimizu on 2020/11/14.
//

import WidgetKit
import SwiftUI

private struct MonsterProvider {
    typealias Entry = MonsterEntry
    typealias Intent = SelectMonsterIntent

    private let imageManager: ImageCacheManagerProtocol

    init(imageManager: ImageCacheManagerProtocol) {
        self.imageManager = imageManager
    }
}

struct MonsterConfigurableWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "MonsterConfigurable",
            intent: SelectMonsterIntent.self,
            provider: MonsterProvider(imageManager: ImageCacheManager())
        ) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName("Configuration display name")
        .description("Configurable description")
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
            let entry = try? await convertDTOToEntry(dto: intent.monster?.convertToDTO())
            let entries = [entry ?? .createDefault()]
            completion(Timeline(entries: entries, policy: .never))
        }
    }

    private func convertDTOToEntry(dto: MonsterDTO?) async throws -> Entry? {
        guard let dto = dto, let iconUrl = URL(string: dto.iconUrlString) else {
            return nil
        }
        let icon = try await imageManager.cacheImage(imageUrl: iconUrl)
        let description = dto.description.replacingOccurrences(of: "\\n", with: "\n")
        return Entry(date: Date(), name: dto.name, description: description, icon: icon)
    }
}
