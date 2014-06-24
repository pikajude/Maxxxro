//
//  AppDelegate.swift
//  Maxxxro-S
//
//  Created by Joel on 6/2/14.
//  Copyright (c) 2014 Joel. All rights reserved.
//

import Cocoa

func toState(x: Bool) -> NSInteger {
    if x { return NSOnState } else { return NSOffState }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var _start: CGEventRef?
    var _stop: CGEventRef?
    var timer: NSTimer!
    var _macroButton: NSInteger?
    var keyCode: Int?
    var _buttonPusher: ButtonPusher?

    @IBOutlet var window: NSWindow
    
    @IBOutlet var interval: NSTextField
    @IBOutlet var duration: NSTextField
    
    @IBOutlet var cButton: NSButton
    @IBOutlet var zButton: NSButton
    @IBOutlet var spaceButton: NSButton
    
    @IBOutlet var catcher: DemoCatcher
    
    @IBAction func pickKey(sender: NSButton) {
        self.updateKeyButtons(sender.tag)
    }
    
    func updateInterval(i: NSInteger) {
    }
    
    func updateDuration(i: NSInteger) {
    }
    
    func updateKeyButtons(keyCode: Int) {
        self.zButton.state = toState(keyCode == 6)
        self.cButton.state = toState(keyCode == 8)
        self.spaceButton.state = toState(keyCode == 49)
        
        NSUserDefaults.standardUserDefaults().setInteger(keyCode, forKey: "macroKey")
        self.keyCode = keyCode
        if self._buttonPusher {
            self._buttonPusher!.keyCode = self.keyCode!
        }
    }

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        NSUserDefaults.standardUserDefaults().registerDefaults(["interval": 150, "duration": 100, "macroKey": 8])
        self.updateKeyButtons(NSUserDefaults.standardUserDefaults().integerForKey("macroKey"))
        
        let intTrans = IntervalTransformer(delegate: self)
        let durTrans = DurationTransformer(delegate: self)
        
        self.interval.bind("value",
            toObject: NSUserDefaultsController.sharedUserDefaultsController(),
            withKeyPath: "values.interval",
            options: [NSValueTransformerBindingOption: intTrans, NSContinuouslyUpdatesValueBindingOption: false])
        
        self.duration.bind("value",
            toObject: NSUserDefaultsController.sharedUserDefaultsController(),
            withKeyPath: "values.duration",
            options: [NSValueTransformerBindingOption: durTrans,
                NSContinuouslyUpdatesValueBindingOption: false])
        
        if self.acquirePrivileges() {
            self.startup()
        }
    }
    
    func startup() {
        self.registerEvents()
        self.catcher.becomeFirstResponder()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    func acquirePrivileges() -> Bool {
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions = [trusted: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions)
        if accessEnabled != 1 {
            let alert = NSAlert()
            alert.messageText = "Enable Maxxxro"
            alert.informativeText = "Once you have enabled Maxxxro in System Preferences, click OK."
            alert.beginSheetModalForWindow(self.window, completionHandler: { response in
                if AXIsProcessTrustedWithOptions(privOptions) == 1 {
                    self.startup()
                } else {
                    NSApp.terminate(self)
                }
            })
        }
        return accessEnabled == 1
    }
    
    func registerEvents() {
        self._buttonPusher = ButtonPusher(delegate: self, keyCode: self.keyCode!)
    }
    
    
    func startMacro() {
        let def = NSUserDefaults.standardUserDefaults()
        let int = ((def.objectForKey("interval").doubleValue + def.objectForKey("duration").doubleValue) / 1000)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(int, target: self._buttonPusher, selector: "press", userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    func stopMacro() {
        self.timer?.invalidate()
        self.timer = nil
    }
}

