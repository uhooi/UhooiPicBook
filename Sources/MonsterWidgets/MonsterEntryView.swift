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
            iconAndNameView
                .padding()
        case .systemMedium:
            HStack(spacing: 16) {
                iconAndNameView
                descriptionText
            }
            .padding()
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
    var iconAndNameView: some View {
        VStack(spacing: 8) {
            iconImage
            nameText
        }
    }

    var iconImage: some View {
        Image(uiImage: entry.icon)
            .resizable()
            .scaledToFit()
            .accessibilityLabel(Text(entry.name))
    }

    var nameText: some View {
        Text(entry.name)
            .font(.headline)
    }

    var descriptionText: some View {
        Text(entry.description)
            .font(.body)
    }
}

// MARK: - Previews

struct MonsterEntryView_Previews: PreviewProvider {
    typealias Entry = MonsterEntry

    static var previews: some View {
        ForEach(families, id: \.self) { family in
            previewEntryViewGroup
                .previewContext(WidgetPreviewContext(family: family))
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
            icon: UIImage(resource: .uhooi)
        )
    }

    private static func longEntry() -> Entry {
        .init(
            date: .now,
            name: "123456789012345678901234567890",
            description: "12345678901234567890\n12345678901234567890\n12345678901234567890",
            icon: UIImage(resource: .uhooi)
        )
    }
}
