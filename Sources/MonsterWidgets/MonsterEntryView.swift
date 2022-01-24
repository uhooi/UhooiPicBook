//
//  MonsterEntryView.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/11/10.
//

import WidgetKit
import SwiftUI

public struct MonsterEntryView: View {
    var entry: MonsterEntry
    @Environment(\.widgetFamily) private var family

    public var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                Color(.systemBackground)
                VStack {
                    icon
                    Spacer(minLength: 8.0)
                    name
                }
                .padding()
            }
        case .systemMedium:
            ZStack {
                Color(.systemBackground)
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
            }
        case .systemLarge, .systemExtraLarge:
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

    public init(entry: MonsterEntry) {
        self.entry = entry
    }
}

struct MonsterEntryView_Previews: PreviewProvider {
    typealias Entry = MonsterEntry

    static var previews: some View {
        ForEach(0..<families.count, id: \.self) { index in
            previewEntryViewGroup
                .previewContext(WidgetPreviewContext(family: families[index]))
        }
    }

    private static let families: [WidgetFamily] = [.systemSmall, .systemMedium]

    private static var previewEntryViewGroup: some View {
        Group {
            MonsterEntryView(entry: .placeholder())
                .redacted(reason: .placeholder)
            MonsterEntryView(entry: .placeholder())
            MonsterEntryView(entry: .placeholder())
                .environment(\.colorScheme, .dark)
            MonsterEntryView(entry: shortEntry())
            MonsterEntryView(entry: longEntry())
        }
    }

    private static func shortEntry() -> Entry {
        .init(
            date: Date(),
            name: "1",
            description: "1",
            icon: R.Image.uhooiIcon
        )
    }

    private static func longEntry() -> Entry {
        .init(
            date: Date(),
            name: "123456789012345678901234567890",
            description: "12345678901234567890\n12345678901234567890\n12345678901234567890",
            icon: R.Image.uhooiIcon
        )
    }
}
