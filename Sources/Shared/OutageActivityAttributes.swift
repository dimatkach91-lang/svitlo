import ActivityKit
import Foundation

struct OutageActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isPowerOn: Bool
        var nextChangeDate: Date
        var nextSlotRange: String
    }
    var settlementName: String
    var queueName: String
}
