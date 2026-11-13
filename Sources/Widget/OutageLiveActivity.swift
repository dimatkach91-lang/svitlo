import ActivityKit
import WidgetKit
import SwiftUI

@main
struct SvitloWidgetBundle: WidgetBundle {
    var body: some Widget {
        OutageLiveActivityWidget()
    }
}

struct OutageLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OutageActivityAttributes.self) { context in
            HStack(spacing: 14) {
                Image(systemName: context.state.isPowerOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(context.state.isPowerOn ? Color.green : Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(context.attributes.settlementName) • \(context.attributes.queueName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(context.state.isPowerOn ? "Світло є" : "Відключення")
                        .font(.headline.bold())
                }
                Spacer()
                Text(timerInterval: Date.now...context.state.nextChangeDate, countsDown: true)
                    .font(.system(.title3, design: .monospaced).bold())
                    .foregroundStyle(context.state.isPowerOn ? .green : .orange)
                    .multilineTextAlignment(.trailing)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.85))
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.attributes.queueName, systemImage: context.state.isPowerOn ? "bolt.fill" : "bolt.slash.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(context.state.isPowerOn ? .green : .red)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.settlementName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text(context.state.isPowerOn ? "До відключення:" : "До увімкнення:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(timerInterval: Date.now...context.state.nextChangeDate, countsDown: true)
                            .font(.system(.title3, design: .monospaced).bold())
                            .foregroundStyle(context.state.isPowerOn ? .green : .orange)
                    }
                    .padding(.top, 4)
                }
            } compactLeading: {
                HStack(spacing: 4) {
                    Image(systemName: context.state.isPowerOn ? "bolt.fill" : "bolt.slash.fill")
                        .foregroundStyle(context.state.isPowerOn ? .green : .red)
                    Text(context.attributes.queueName.replacingOccurrences(of: " черга", with: "ч"))
                        .font(.caption2.bold())
                }
            } compactTrailing: {
                Text(timerInterval: Date.now...context.state.nextChangeDate, countsDown: true)
                    .frame(width: 52)
                    .font(.system(.caption2, design: .monospaced).bold())
                    .foregroundStyle(context.state.isPowerOn ? .green : .orange)
            } minimal: {
                Image(systemName: context.state.isPowerOn ? "bolt.fill" : "bolt.slash.fill")
                    .foregroundStyle(context.state.isPowerOn ? .green : .red)
            }
        }
    }
}
