//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Shawn Frank on 24/7/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), record: .placeholder())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let url = URL(string: "https://api.jsonbin.io/v3/b/64be53208e4aa6225ec29c5a")!
            
            do {
                let record: Record = try await WidgetService().fetchData(url: url)
                let entry = SimpleEntry(date: .now, record: record)
                completion(entry)
            }
            catch {
                completion(SimpleEntry(date: .now, record: .placeholder()))
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let url = URL(string: "https://api.jsonbin.io/v3/b/64be53208e4aa6225ec29c5a")!
            
            do {
                let record: Record = try await WidgetService().fetchData(url: url)
                let image = try await WidgetService().downloadImage(from: URL(string: record.image)!)
        
                let entry = SimpleEntry(date: .now, record: record, downloadImage: image)
                let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 60*60*30)))
                
                completion(timeline)
            }
            catch {
                let entries = [SimpleEntry(date: .now, record: .placeholder())]
                let timeline = Timeline(entries: entries, policy: .after(.now.advanced(by: 60*60*30)))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let record: Record
    let downloadImage: UIImage?
    
    init(date: Date, record: Record, downloadImage: UIImage? = nil) {
        self.date = date
        self.record = record
        self.downloadImage = downloadImage
    }
}

struct WidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        MediumSizeView(entry: entry)
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("AFR")
        .description("View the news you care about")
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(entry: SimpleEntry(date: Date(), record: .placeholder()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
