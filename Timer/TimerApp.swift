//
//  TimerApp.swift
//  Timer
//
//  Created by Yanun on 2022/10/1.
//

import SwiftUI

@main
struct TimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
