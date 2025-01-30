//
//  CountDownView.swift
//  Union
//
//  Created by 박서연 on 1/29/25.
//

import SwiftUI
import Combine

class CountdownTimer: ObservableObject {
    @Published private(set) var timeComponents: (days: Int, hours: Int, minutes: Int, seconds: Int) = (0, 0, 0, 0)
    
    private var cancellable: AnyCancellable?
    private let targetDate: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 3))!
    
    init() {
        startTimer()
    }
    
    private func startTimer() {
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
        updateTimeRemaining()
    }
    
    private func updateTimeRemaining() {
        let timeRemaining = max(0, targetDate.timeIntervalSinceNow)
        let days = Int(timeRemaining) / (24 * 3600)
        let hours = (Int(timeRemaining) % (24 * 3600)) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        timeComponents = (days, hours, minutes, seconds)
    }
    
    deinit {
        cancellable?.cancel()
    }
}

enum Time: String, CaseIterable {
    case day = "DAY"
    case hr = "HR"
    case min = "MIN"
    case sec = "SEC"
    
    /// `CountdownTimer`의 `timeComponents`에서 각 케이스에 맞는 값을 반환
    func value(from components: (days: Int, hours: Int, minutes: Int, seconds: Int)) -> Int {
        switch self {
        case .day:
            return components.days
        case .hr:
            return components.hours
        case .min:
            return components.minutes
        case .sec:
            return components.seconds
        }
    }
}
