import SwiftUI
import ActivityKit

@main
struct SvitloApp: App {
    var body: some Scene {
        WindowGroup {
            MainOutageView()
        }
    }
}

struct MainOutageView: View {
    @AppStorage("settlement") private var settlement = "м. Рівне"
    @AppStorage("queue") private var queue = "1 черга"
    @State private var isPowerOn = true
    @State private var hoursLeft = 3
    @State private var isIslandActive = false
    
    let queues = ["1 черга", "2 черга", "3 черга", "4 черга", "5 черга", "6 черга"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Населений пункт та черга") {
                    TextField("Місто або село (напр. м. Рівне, с. Гоща)", text: $settlement)
                    Picker("Черга ГПВ", selection: $queue) {
                        ForEach(queues, id: \.self) { Text($0) }
                    }
                }
                
                Section("Поточний стан за графіком") {
                    Toggle("Зараз світло є", isOn: $isPowerOn)
                    Stepper("Зміна через: \(hoursLeft) год.", value: $hoursLeft, in: 1...12)
                }
                
                Section {
                    Button {
                        startOrUpdateDynamicIsland()
                    } label: {
                        Label("Вивести в Dynamic Island", systemImage: "island.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    if isIslandActive {
                        Button(role: .destructive) {
                            stopDynamicIsland()
                        } label: {
                            Text("Зупинити Dynamic Island")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle("Світло Україна")
        }
    }
    
    private func startOrUpdateDynamicIsland() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let targetDate = Calendar.current.date(byAdding: .hour, value: hoursLeft, to: Date()) ?? Date()
        let state = OutageActivityAttributes.ContentState(
            isPowerOn: isPowerOn,
            nextChangeDate: targetDate,
            nextSlotRange: "за графіком ОСР"
        )
        let attrs = OutageActivityAttributes(settlementName: settlement, queueName: queue)
        
        Task {
            for activity in Activity<OutageActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            _ = try? Activity.request(
                attributes: attrs,
                content: ActivityContent(state: state, staleDate: targetDate),
                pushType: nil
            )
            isIslandActive = true
        }
    }
    
    private func stopDynamicIsland() {
        Task {
            for activity in Activity<OutageActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            isIslandActive = false
        }
    }
}
