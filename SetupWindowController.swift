//
//  SetupWindowController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 27/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import Collaboration

class SetupWindowController: NSWindowController, NSWindowDelegate {
    let gestureInstructions1 = "Move the cursor inside this box to record your gesture sequence."
    let gestureInstructions2 = "Start recording your gesture sequence using two fingers on the trackpad!"
    
    @IBOutlet var settingsWindow: NSWindow!
    @IBOutlet var prova: NSView!
    @IBOutlet var timeTextField: NSTextField!
    @IBOutlet var accuracyTextField: NSTextField!
    @IBOutlet var setGestureImage: NSButton!
    @IBOutlet var gestureTimeSliderCell: NSSliderCell!
    @IBOutlet var accuracyTimeSlider: NSSlider!
    @IBOutlet var updatePasswordButton: NSButtonCell!
    
    @IBOutlet var soundsEnabledButton: NSButton!
    @IBOutlet var launchAtLoginButton: NSButton!
    @IBOutlet var retryButton: NSButton!
    
    @IBOutlet var continueAniwayButton: NSButton!
    //tab view
    @IBOutlet var tabView: NSTabView!
    
    //tab view items
    @IBOutlet var passwordTabViewItem: NSTabViewItem!
    @IBOutlet var gesturesTabViewItem: NSTabViewItem!
    
    @IBOutlet var passwordField: NSSecureTextField!
    @IBOutlet var logoImageView: NSImageView!
    @IBOutlet var passwordAlertTextField: NSTextField!
    @IBOutlet var passwordOkField: NSTextField!
    
    @IBOutlet var launchAtLoginWarning: NSTextField!
    @IBOutlet var thumbsUpImageView: NSImageView!
    @IBOutlet var thumbsDownImageView: NSImageView!
    @IBOutlet var mouseImageView: NSImageView!
    @IBOutlet var scrollImageView: NSImageView!
    @IBOutlet var confirmGestureWithPasswordLabel: NSTextField!
    
    @IBOutlet var countGesturesButton: NSButton!
    @IBOutlet var countGesturesLabel: NSTextField!
    @IBOutlet var gestureInstructionsLabel: NSTextField!
    @IBOutlet var orLabel: NSTextField!
    
    let dataShare = DataShare.sharedInstance
    var mouseOverEnabled: Bool = true
    
    override func showWindow(sender: AnyObject?) {
        if settingsWindow != nil && settingsWindow.miniaturized { //if it is miniaturized, deminiaturize
            settingsWindow.deminiaturize(settingsWindow)
            settingsWindow.orderFrontRegardless()
        } else if(settingsWindow != nil && settingsWindow.visible){ //if it is somewhere already open, show to the front
            settingsWindow.collectionBehavior = .MoveToActiveSpace
            settingsWindow.orderFrontRegardless()
        } else {
            super.showWindow(sender)
            settingsWindow.orderFrontRegardless()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        mouseOverEnabled = true
        
        //register itself
        dataShare.setupWindowControllerInstance = self
        dataShare.sequenceBeingRecorded = nil
        
        
        //******** BLURRED BACKGROUND *************
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
         visualEffectView.material = NSVisualEffectMaterial.Dark
         visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
         visualEffectView.state = NSVisualEffectState.Active
         
         let previousContentView = settingsWindow.contentView
         settingsWindow.contentView = visualEffectView //add the visual effect
         settingsWindow.contentView?.addSubview(previousContentView!)
        
        
        //******** BACKGROUND GRADIENT *************
        /*settingsWindow.contentView!.wantsLayer = true
         let layer = CAGradientLayer()
         layer.frame = settingsWindow.contentLayoutRect
         layer.colors = [
         /*NSColor(red: 107/255, green: 210/255, blue: 118/255, alpha: 1).CGColor,*/
         GlobalConstants.Colors.purple,
         GlobalConstants.Colors.lightPurple,
         GlobalConstants.Colors.pink,
         GlobalConstants.Colors.yellow
         
         ]
         layer.startPoint = NSPoint(x: 0, y: 0)
         layer.endPoint = NSPoint(x: 1, y: 0.3)
         layer.zPosition = -1
         settingsWindow.contentView?.layer?.addSublayer(layer)*/
        
        
        //******** BACKGROUND IMAGE *************
        /*settingsWindow.contentView!.wantsLayer = true
        settingsWindow.contentView?.layer?.contents = NSImage(named: "background3.png")*/
        
        
        settingsWindow.styleMask = [NSFullSizeContentViewWindowMask, NSTitledWindowMask, NSClosableWindowMask, NSMiniaturizableWindowMask]
        settingsWindow.titleVisibility = .Hidden
        settingsWindow.titlebarAppearsTransparent = true
        settingsWindow.movableByWindowBackground = true
        settingsWindow.releasedWhenClosed = false
        
        addLogo()
        
        thumbsUpImageView.hidden = true
        thumbsDownImageView.hidden = true
        passwordField.bezeled = false
        passwordField.bezelStyle = NSTextFieldBezelStyle.SquareBezel
        
        
        //tabView.selectFirstTabViewItem(self)
        box1.hidden = false
        box2.hidden = true
        box3.hidden = true
        
        
        //let bounds = gesturesTabViewItem.view?.bounds
        //gesturesTabViewItem.view?.addTrackingRect(bounds!, owner: self, userData: nil, assumeInside: true)
        box1.contentView?.addTrackingRect(box1.bounds, owner: self, userData: nil, assumeInside: true)
        
        //get gesture time
        let time = KeychainManager.getGestureTime()
        updateTimeLabel(time!)
        gestureTimeSliderCell.integerValue = time as! Int
        
        //get accuracy
        let accuracy = KeychainManager.getPrecision()
        accuracyTimeSlider.floatValue = Float(accuracy! as CGFloat)*100
        updateAccuracyLabel(accuracy!*100)
        
        //init
        passwordAlertTextField.stringValue = ""
        passwordOkField.stringValue = ""
        scrollImageView.hidden = true
        mouseImageView.hidden = false
        countGesturesButton.hidden = true
        countGesturesLabel.hidden = true
        countGesturesButton.title = "0"
        countGesturesLabel.stringValue = "gestures"
        gestureInstructionsLabel.stringValue = gestureInstructions1
        confirmGestureWithPasswordLabel.hidden = true
        //if KeychainManager.isLaunchAtLoginSet() && KeychainManager.getLaunchAtLogin() == true {
        if LaunchAtLoginManager.applicationIsInStartUpItems() {
            launchAtLoginButton.state = NSOnState
            launchAtLoginWarning.hidden = true
        } else {
            launchAtLoginButton.state = NSOffState
            launchAtLoginWarning.hidden = false
        }
        
        if KeychainManager.areSoundsEnabledSet() && KeychainManager.getSoundsEnabled()! {
            soundsEnabledButton.state = NSOnState
        } else {
            soundsEnabledButton.state = NSOffState
        }
        
        
        //labels
        if KeychainManager.isPasswordSet() {
            //passwordTabViewItem.label = "Update password"
            segmentedControl.setLabel("Update password", forSegment: 1)
            updatePasswordButton.title = "Update password"
        } else {
            //passwordTabViewItem.label = "Set password"
            segmentedControl.setLabel("Set password", forSegment: 1)
            updatePasswordButton.title = "Set password"
        }
        
        if KeychainManager.isSequenceSet() {
            //gesturesTabViewItem.label = "Update sequence"
            segmentedControl.setLabel("Update sequence", forSegment: 0)
        } else {
            //gesturesTabViewItem.label = "Set sequence"
            segmentedControl.setLabel("Set sequence", forSegment: 0)
        }
        
        //passwordTabViewItem.initialFirstResponder = passwordField //todo it doesn't work
        
        showRetryContinueAnyway(false)
        
    }
    
    func windowWillClose(notification: NSNotification) {
        //reset stuff, otherwise everything is like the last time when opening the window again
        windowDidLoad()
    }
    
    func addLogo() {
        //tint the logo
        let logo = logoImageView.image
        logo!.lockFocus()
        GlobalConstants.Colors.green.set()
        //NSColor.whiteColor().set()
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.SourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoImageView.image = logo
        logoImageView.imageScaling = .ScaleProportionallyUpOrDown
    }
    
    @IBAction func timeChanged(sender: NSSlider) {
        updateTimeLabel(NSNumber(int: sender.intValue)) //update label
        
        //if mouseUp
        if NSApplication.sharedApplication().currentEvent?.type == NSEventType.LeftMouseUp {
            KeychainManager.setGestureTime(NSNumber(int: sender.intValue))
        }
    }
    
    func updateTimeLabel(time: NSNumber) {
        timeTextField.stringValue = time.description+" ms"
    }
    
    @IBAction func accuracyChanged(sender: NSSlider) {
        updateAccuracyLabel(CGFloat(sender.intValue)) //update label
        
        //if mouseUp
        if NSApplication.sharedApplication().currentEvent?.type == NSEventType.LeftMouseUp {
            KeychainManager.setPrecision(CGFloat(sender.intValue)/100)
        }
    }
    
    func updateAccuracyLabel(accuracy: CGFloat) {
        accuracyTextField.stringValue = Int(accuracy).description+"%"
    }
    
    @IBAction func updatePassword(sender: AnyObject) {
        //check if the password is correct
        let identity = CBUserIdentity(posixUID: getuid(), authority: CBIdentityAuthority.defaultIdentityAuthority())
        let passOk = identity?.authenticateWithPassword(passwordField.stringValue)
        
        if passOk == true {
            KeychainManager.setPassword(NSString(string: passwordField.stringValue)) //store the password
            
            
            
            //update labels
            //passwordOkField.stringValue = "Your password has been securely saved. It will be used only to unlock your Mac."
            passwordAlertTextField.stringValue = ""
            
            //update buttons
            //passwordTabViewItem.label = "Update password"
            segmentedControl.setLabel("Update password", forSegment: 1)
            updatePasswordButton.title = "Update password"
            
            //thumbs up!
            thumbsUpImageView.hidden = false
            thumbsDownImageView.hidden = true
            confirmGestureWithPasswordLabel.hidden = true
            
            
            if dataShare.sequenceBeingRecorded != nil { //if the user is confirming a new sequence
                //save new sequence
                KeychainManager.setSequence(dataShare.sequenceBeingRecorded!)
                dataShare.sequenceBeingRecorded = nil
                
                //notification
                let notification:NSUserNotification = NSUserNotification()
                notification.title = "Sequence set!"
                notification.informativeText = "You can now unlock your mac using the sequence you've just set up."
                
                let notificationcenter = NSUserNotificationCenter.defaultUserNotificationCenter()
                notificationcenter.deliverNotification(notification)
                
                windowDidLoad() //reset in order to update the graphics
                //tabView.selectTabViewItem(gesturesTabViewItem)
                switchToTab(0)
            } else { //otherwise the user is just updating the password
                
                //notification
                let notification:NSUserNotification = NSUserNotification()
                notification.title = "Passowrd updated!"
                notification.informativeText = "Your password has been securely saved. It will be used only to unlock your Mac."
                
                let notificationcenter = NSUserNotificationCenter.defaultUserNotificationCenter()
                notificationcenter.deliverNotification(notification)
            }
            
            
        } else {
            //update labels
            passwordAlertTextField.stringValue = "The given password is not the current user's one."
            passwordOkField.stringValue = ""
            
            //thumbs up!
            thumbsUpImageView.hidden = true
            thumbsDownImageView.hidden = false
            
            //update buttons
            if(dataShare.sequenceBeingRecorded == nil) {
                if KeychainManager.isPasswordSet() {
                    //passwordTabViewItem.label = "Update password"
                    segmentedControl.setLabel("Update password", forSegment: 1)
                    updatePasswordButton.title = "Update password"
                } else {
                    //passwordTabViewItem.label = "Set password"
                    segmentedControl.setLabel("Set password", forSegment: 1)
                    updatePasswordButton.title = "Set password"
                }
            } else {
                if KeychainManager.isSequenceSet() {
                    updatePasswordButton.title = "Update sequence"
                } else {
                    updatePasswordButton.title = "Set sequence"
                }
            }
        }
        
        //clean
        passwordField.stringValue = ""
        
    }
    
    //it's a precondition for recording the gesture
    override func mouseEntered(theEvent: NSEvent) {
        if mouseOverEnabled {
            dataShare.canRecord = true
            
            mouseImageView.hidden = true
            scrollImageView.hidden = false
            countGesturesButton.hidden = false
            countGesturesLabel.hidden = false
            gestureInstructionsLabel.stringValue = gestureInstructions2
        }
    }
    
    override func mouseExited(theEvent: NSEvent) {
        if mouseOverEnabled {
            dataShare.canRecord = false
            
            mouseImageView.hidden = false
            scrollImageView.hidden = true
            countGesturesButton.hidden = true
            countGesturesLabel.hidden = true
            gestureInstructionsLabel.stringValue = gestureInstructions1
        }
        
    }
    
    func updateGestureNumber(number: NSNumber) {
        if number != 0 {
            SoundManager.yesSound()
        }
        countGesturesButton.title = number.description
        if number == 1 {
            countGesturesLabel.stringValue = "gesture"
        } else {
            countGesturesLabel.stringValue = "gestures"
        }
    }
    
    @IBAction func startAtLoginToggle(sender: NSButton) {
        if launchAtLoginButton.state == NSOnState {
            LaunchAtLoginManager.setLaunchAtStartup(true)
            launchAtLoginWarning.hidden = true
        } else {
            LaunchAtLoginManager.setLaunchAtStartup(false)
            launchAtLoginWarning.hidden = false
        }
    }
    
    @IBAction func soundsEnabledToggle(sender: NSButton) {
        if soundsEnabledButton.state == NSOnState {
            KeychainManager.setSoundsEnabled(true)
        } else {
            KeychainManager.setSoundsEnabled(false)
        }
    }
    
    func errorsInGestureSequence(errors: [Message]) {
        mouseOverEnabled = false
        dataShare.canRecord = false
        
        //show graphics
        showRetry(true)
        showSetSequenceGraphics(false)
        
        gestureInstructionsLabel.stringValue = ""
        for (_, element) in errors.enumerate() {
            gestureInstructionsLabel.stringValue += " " + (element.string as String)
        }
    }
    
    func warningsInGestureSequence(warnings: [Message]) {
        mouseOverEnabled = false
        dataShare.canRecord = false
        
        //show graphics
        showRetryContinueAnyway(true)
        showSetSequenceGraphics(false)
        
        gestureInstructionsLabel.stringValue = ""
        for (_, element) in warnings.enumerate() {
            gestureInstructionsLabel.stringValue += " " + (element.string as String)
        }
        
        //reset password label
        if KeychainManager.isPasswordSet() {
            //passwordTabViewItem.label = "Update password"
            segmentedControl.setLabel("Update password", forSegment: 1)
            updatePasswordButton.title = "Update password"
        } else {
            //passwordTabViewItem.label = "Set password"
            segmentedControl.setLabel("Set password", forSegment: 1)
            updatePasswordButton.title = "Set password"
        }
    }
    
    func gestureIsValid() {
        //update password graphics
        if KeychainManager.isSequenceSet() {
            updatePasswordButton.title = "Update sequence"
        } else {
            updatePasswordButton.title = "Set sequence"
        }
        //passwordTabViewItem.label = "Confirm sequence"
        segmentedControl.setLabel("Confirm sequence", forSegment: 0)
        
        thumbsUpImageView.hidden = true
        thumbsDownImageView.hidden = true
        passwordOkField.stringValue = ""
        passwordAlertTextField.stringValue = ""
        
        //switch to password tab
        //tabView.selectTabViewItem(passwordTabViewItem)
        switchToTab(1)
        
        confirmGestureWithPasswordLabel.hidden = false
        
        //focus on the password field
        passwordField.becomeFirstResponder()
        
        //init the gesture tab
        scrollImageView.hidden = true
        mouseImageView.hidden = false
        countGesturesButton.hidden = true
        countGesturesLabel.hidden = true
        countGesturesButton.title = "0"
        countGesturesLabel.stringValue = "gestures"
        gestureInstructionsLabel.stringValue = gestureInstructions1
        showRetryContinueAnyway(false)
        
    }
    
    func showSetSequenceGraphics(show: Bool) {
        scrollImageView.hidden = !show
        mouseImageView.hidden = !show
        countGesturesLabel.hidden = !show
        countGesturesButton.hidden = !show
        gestureInstructionsLabel.stringValue = gestureInstructions2
    }
    
    func showRetryContinueAnyway(show: Bool) {
        showRetry(show)
        showContinueAnyway(show)
    }
    
    func showRetry(show: Bool) {
        retryButton.hidden = !show
    }
    
    func showContinueAnyway(show: Bool) {
        orLabel.hidden = !show
        continueAniwayButton.hidden = !show
    }
    
    
    @IBAction func retryPressed(sender: AnyObject) {
        showRetryContinueAnyway(false)
        showSetSequenceGraphics(true)
        //fix, the mouse is on the screen, hide the mouse icon
        mouseImageView.hidden = true
        
        dataShare.sequenceBeingRecorded = nil
        mouseOverEnabled = true
        dataShare.canRecord = true
    }
    
    @IBAction func continueAnywayPressed(sender: AnyObject) {
        showRetryContinueAnyway(false)
        showSetSequenceGraphics(true)
        
        mouseOverEnabled = true
        //switch to password tab
        gestureIsValid()
    }
    
    
    //EXPERIMENTAL
    @IBOutlet var box1: NSBox!
    @IBOutlet var box2: NSBox!
    @IBOutlet var box3: NSBox!
    
    @IBOutlet var segmentedControl: NSSegmentedControl!
    
    @IBAction func segmentedControlPressed(sender: NSSegmentedCell) {
        switchToTab(sender.selectedSegment)
        
    }
    
    func switchToTab(index: Int) {
        switch index {
        case 0:
            box1.hidden = false
            box2.hidden = true
            box3.hidden = true
            segmentedControl.selectedSegment = 0
        case 1:
            box1.hidden = true
            box2.hidden = false
            box3.hidden = true
            segmentedControl.selectedSegment = 1
        case 2:
            box1.hidden = true
            box2.hidden = true
            box3.hidden = false
            segmentedControl.selectedSegment = 2
        default:
            box1.hidden = true
            box2.hidden = true
            box3.hidden = true
            segmentedControl.selectedSegment = 0
        }
    }
    
    
}
