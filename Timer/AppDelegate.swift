//
//  AppDelegate.swift
//  Timer
//
//  Created by Yanun on 2022/10/1.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @State var icon = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)
    private var statusItem: NSStatusItem?
    private var popOver = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        popOver.setValue(true, forKeyPath: "shouldHideAnchor")
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentSize = CGSize(width: 200, height: 300)
        popOver.contentViewController = NSViewController()
        popOver.contentViewController = NSHostingController(rootView: ContentView())
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem?.button {
            statusButton.image = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)
            statusButton.action = #selector(togglePopover)
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem?.button {
            self.popOver.show(relativeTo:  button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
        }
        
    }
}
