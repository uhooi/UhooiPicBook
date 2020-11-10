//
//  MonsterEntryView.swift
//  UhooiPicBookWidgets
//
//  Created by uhooi on 2020/11/10.
//

import WidgetKit
import SwiftUI

struct MonsterEntryView : View {
    var entry: MonsterWidget.Provider.Entry
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
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

struct MonsterEntryView_Previews: PreviewProvider {
    typealias Entry = MonsterWidget.Entry
    
    static var previews: some View {
        previewEntryViewGroup
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        previewEntryViewGroup
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    
    static private var previewEntryViewGroup: some View {
        Group {
            MonsterEntryView(entry: .createDefault())
                .redacted(reason: .placeholder)
            MonsterEntryView(entry: .createDefault())
            MonsterEntryView(entry: .createDefault())
                .environment(\.colorScheme, .dark)
            MonsterEntryView(entry: createShortEntry())
            MonsterEntryView(entry: createLongEntry())
        }
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
