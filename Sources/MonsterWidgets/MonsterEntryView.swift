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
                iconAndName
                    .padding()
            }
        case .systemMedium:
            ZStack {
                Color(.systemBackground)
                HStack {
                    iconAndName
                    Spacer(minLength: 16.0)
                    description
                }
                .padding()
            }
        case .systemLarge, .systemExtraLarge:
            EmptyView()
        case .accessoryCircular, .accessoryRectangular, .accessoryInline:
            // TODO: Implement for the Lock Screen.
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }

    public init(entry: MonsterEntry) {
        self.entry = entry
    }
}

// MARK: - Privates

private extension MonsterEntryView {
    var iconAndName: some View {
        VStack {
            icon
            Spacer(minLength: 8.0)
            name
        }
    }

    var icon: some View {
        Image(uiImage: entry.icon)
            .resizable()
            .scaledToFit()
            .accessibilityLabel(Text(entry.name))
    }

    var name: some View {
        Text(entry.name)
            .font(.headline)
    }

    var description: some View {
        Text(entry.description)
            .font(.body)
    }
}

// MARK: - Previews

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
            date: .now,
            name: "1",
            description: "1",
            icon: R.Image.uhooiIcon
        )
    }

    private static func longEntry() -> Entry {
        .init(
            date: .now,
            name: "123456789012345678901234567890",
            description: "12345678901234567890\n12345678901234567890\n12345678901234567890",
            icon: R.Image.uhooiIcon
        )
    }
}
