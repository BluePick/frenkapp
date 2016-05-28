//
//  AppDelegate.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 09/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    var settingsWindow2 = NSWindowController()
    var aboutWindow = NSWindowController()
    
    
    let widthSetup : CGFloat = 450
    let heightSetup : CGFloat = 300
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) //get the system status bar
    let gestureWindow = NSWindow()
    let settingsWindow = NSWindow()
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        settingsWindow2 = SetupWindowController(windowNibName: "SetupWindowController")
        aboutWindow = AboutWindowController(windowNibName: "AboutWindowController")
        
    }
    @IBAction func openAbout(sender: AnyObject) {
        aboutWindow.showWindow(sender)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func nemuQuit(sender: NSMenuItem) {
        exit(0)
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        settingsWindow2.showWindow(sender)
    
    }
    
    @IBAction func menuSetGesture(sender: NSMenuItem) {
        if(gestureWindow.miniaturized) { //if it is miniaturized, deminiaturize
            gestureWindow.deminiaturize(gestureWindow)
            gestureWindow.orderFrontRegardless()
        } else if(gestureWindow.visible){ //if it is somewhere already open, show to the front
            gestureWindow.collectionBehavior = .MoveToActiveSpace
            gestureWindow.orderFrontRegardless()
        } else { //otherwise it was not open, so create a new one
            let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"
            
            let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
            darkMode == true ? (visualEffectView.material = NSVisualEffectMaterial.UltraDark) : (visualEffectView.material = NSVisualEffectMaterial.Light)
            visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
            visualEffectView.state = NSVisualEffectState.Active
            gestureWindow.contentView = visualEffectView //add the visual effect
            
            gestureWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
            gestureWindow.titleVisibility = .Hidden
            gestureWindow.titlebarAppearsTransparent = true
            gestureWindow.movableByWindowBackground = true
            gestureWindow.setContentSize(NSSize(width:widthSetup, height:heightSetup))
            gestureWindow.center()
            gestureWindow.releasedWhenClosed = false
            
            
            
            addSetupElements(darkMode)
            
            
            
            
            
            gestureWindow.orderFrontRegardless() //show itself and make it the frontmost window
            
        }
        
    }
    
    func addSetupElements(darkMode : Bool) {
        //adding the logo
        let widthLogo : CGFloat = 60
        let heightLogo : CGFloat = 60
        let logoView = NSImageView(frame: NSRect(x: widthSetup/2-widthLogo/2, y: heightSetup-widthLogo-30, width: widthLogo, height: heightLogo))
        //tint the logo
        let logo = NSImage(named: "frenk_logo.png")
        logo!.lockFocus()
        darkMode == true ? (NSColor(red: 0.25, green: 0.75, blue: 0.793, alpha: 1).set()) : (NSColor(red: 0.75, green: 0.25, blue: 0.193, alpha: 1).set())
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoView.image = logo
        logoView.imageScaling = .ScaleProportionallyUpOrDown
        gestureWindow.contentView!.addSubview(logoView)
    }
    
    internal func recordngGesture(event : NSEvent) -> NSEvent {
        
        print("fefefefeefefefefefefefefe")
        return NSEvent()
    }
    
    /*let checkURL = NSURL(string: "http://www.google.com")
     NSWorkspace.sharedWorkspace().openURL(checkURL!)*/
    
    
}

