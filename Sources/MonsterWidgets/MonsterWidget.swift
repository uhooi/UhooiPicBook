//
//  MonsterWidget.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/11/09.
//

import WidgetKit
import SwiftUI
import FirebaseSetup
import MonstersRepository
import ImageLoader
import Logger
import Shared

private struct MonsterProvider {
    typealias Entry = MonsterEntry

    private let monstersRepository: MonstersRepository
    private let logger: LoggerProtocol

    init(
        monstersRepository: MonstersRepository = MonstersFirestoreClient.shared,
        logger: LoggerProtocol = Logger.default
    ) {
        self.monstersRepository = monstersRepository
        self.logger = logger
    }
}

public struct MonsterWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "Monster",
            provider: MonsterProvider()
        ) { entry in
            MonsterEntryView(entry: entry)
        }
        .configurationDisplayName(R.LocalizedString.configurationDisplayName)
        .description(R.LocalizedString.description)
        .supportedFamilies([.systemSmall, .systemMedium])
    }

    public init() {
        FirebaseSetup.configure()
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
        Task {
            var entries: [Entry] = []
            do {
                let monsters = try await monstersRepository.loadMonsters()
                let currentDate = Date()
                var hourOffset = 0
                for monster in monsters.sorted(by: { $0.order < $1.order }) {
                    guard let iconURL = URL(string: monster.iconURLString),
                          let icon = await UIImage.create(url: iconURL)
                    else {
                        continue
                    }

                    guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else {
                        fatalError("Fail to unwrap `entryDate`. hourOffset: \(hourOffset), currentDate: \(currentDate)")
                    }
                    let description = monster.description.replacingOccurrences(of: "\\n", with: "\n")
                    let entry = Entry(date: entryDate, name: monster.name, description: description, icon: icon)
                    entries.append(entry)
                    hourOffset += 1
                }
            } catch {
                logger.exception(error, file: #file, function: #function, line: #line, column: #column)
            }
            completion(Timeline(entries: entries, policy: .atEnd))
        }
    }
}
