//
//  ContentView.swift
//  Hyundone
//
//  Created by Tristan Chay on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    
    enum CarProgress: CaseIterable {
        case suspension
        case suspensionFrame
        case suspensionFrameDoors
        case suspensionFrameDoorsWindshield
        case suspensionFrameDoorsWindshieldWheels
        case qc
        case testing
        case passedAllTests
        case readyForCollection
        
        var imageName: String {
            switch self {
            case .suspension: return "suspension"
            case .suspensionFrame: return "carframe"
            case .suspensionFrameDoors: return "wheelless windshieldless"
            case .suspensionFrameDoorsWindshield: return "wheelless"
            case .suspensionFrameDoorsWindshieldWheels: return "car"
            case .qc: return "car"
            case .testing: return "car"
            case .passedAllTests: return "car"
            case .readyForCollection: return "car"
            }
        }
        
        var percentageDone: Double {
            switch self {
            case .suspension: return 0.1
            case .suspensionFrame: return 0.4
            case .suspensionFrameDoors: return 0.5
            case .suspensionFrameDoorsWindshield: return 0.7
            case .suspensionFrameDoorsWindshieldWheels: return 0.8
            case .qc: return 0.9
            case .testing: return 0.95
            case .passedAllTests: return 0.99
            case .readyForCollection: return 1
            }
        }
        
        var carProgressDescription: [String] {
            switch self {
            case .suspension:
                return ["Retrieved suspension"]
            case .suspensionFrame:
                return ["Retrieved suspension", "Fitted frame"]
            case .suspensionFrameDoors:
                return ["Retrieved suspension", "Fitted frame", "Attached doors"]
            case .suspensionFrameDoorsWindshield:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield"]
            case .suspensionFrameDoorsWindshieldWheels:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield", "Attached wheels"]
            case .qc:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield", "Attached wheels", "Undergoing quality checks"]
            case .testing:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield", "Attached wheels", "Undergoing quality checks", "Car testing in progress"]
            case .passedAllTests:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield", "Attached wheels", "Undergoing quality checks", "Car testing in progress", "Car passed all tests"]
            case .readyForCollection:
                return ["Retrieved suspension", "Fitted frame", "Attached doors", "Attached windshield", "Attached wheels", "Undergoing quality checks", "Car testing in progress", "Car passed all tests", "Ready for collection"]
            }
        }
    }
    
    @State var seconds = 2
    @State var progress: CarProgress = .suspension
    
    var body: some View {
        
        let timer = Timer.publish(every: TimeInterval(seconds), on: .main, in: .common).autoconnect()
        
        NavigationStack {
            List {
                Section("Status") {
                    ForEach(progress.carProgressDescription.reversed(), id: \.self) { progress in
                        Text(progress)
                    }
                    .onReceive(timer) { _ in
                        nextStep()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Stepper("\(seconds)") {
                        seconds += 1
                    } onDecrement: {
                        if seconds > 1 {
                            seconds -= 1
                        }
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Next step") {
                            nextStep()
                        }
                        Divider()
                        Button("Reset progress", role: .destructive) {
                            progress = .suspension
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                VStack {
                    Image(progress.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .animation(.default, value: progress)
                    ProgressView(value: progress.percentageDone, total: 1) {
                        if progress == .readyForCollection {
                            Text("Ready for collection")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("Progress: \(progress.percentageDone * 100, specifier: "%.1f")%")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .progressViewStyle(.linear)
                    .animation(.default, value: progress)
                }
                .padding([.horizontal, .bottom])
                .background(Color(uiColor: UIColor.systemGroupedBackground))
            }
        }
    }
    
    func nextStep() {
        switch progress {
        case .suspension:
            progress = .suspensionFrame
        case .suspensionFrame:
            progress = .suspensionFrameDoors
        case .suspensionFrameDoors:
            progress = .suspensionFrameDoorsWindshield
        case .suspensionFrameDoorsWindshield:
            progress = .suspensionFrameDoorsWindshieldWheels
        case .suspensionFrameDoorsWindshieldWheels:
            progress = .qc
        case .qc:
            progress = .testing
        case .testing:
            progress = .passedAllTests
        case .passedAllTests:
            progress = .readyForCollection
        case .readyForCollection:
            break
        }
    }
}

#Preview {
    ContentView()
}
