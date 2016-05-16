//
//  GestureManager.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 15/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import Foundation

class GestureManager {
    //variables initialization
    var gestures = [Gesture]()
    private var referenceGestures : [Gesture]
    private var isScreenLocked = false
    var lastGestureTimer = NSTimer.init()
    
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    init(referenceGestures : [Gesture]) {
        self.referenceGestures = referenceGestures
    }
    
    func scroll(event: NSEvent) {
        if(event.phase == NSEventPhase.Began) {
            let newGesture = Gesture()
            newGesture.timeStart = event.timestamp
            gestures.append(newGesture)
            lastGestureTimer.invalidate()
            x = 0
            y = 0
            print("gesture started")
        } else if(event.phase == NSEventPhase.Changed) {
            
            x += event.deltaX
            y += event.deltaY
            gestures.last?.xPoints.append(x)
            gestures.last?.yPoints.append(y)
            
        } else if(event.phase == NSEventPhase.Ended) {
            gestures.last?.timeEnd = event.timestamp
            print("gesture ended, last one?")
            
            //print(gestures.last?.xPoints)
            //print(gestures.last?.yPoints)
            
            //gesture ended, last one?
            lastGestureTimer.invalidate()
            lastGestureTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.lastGestureTimerFired(_:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func lastGestureTimerFired(timer : NSTimer!) {
        print(" yes, last gesture")
        //it was the last gesture
        
        print("is the screen locked?")
        if(isScreenLocked) {
            print(" yes, the screen is locked")
            print("are the gestures matching the stored ones?")
            if(areGesturesCorrelated()) {
                print(" yes, unlocking...")
                unlock()
            } else {
                print(" no")
            }
        } else {
            print("  no, the screen is not locked")
        }
        
        //delete gestures
        gestures.removeAll()
    }
    
    func isScreenLocked(locked : Bool) {
        print("screen locked = " + locked.description)
        isScreenLocked = locked
    }
    
    private func areGesturesCorrelated() -> Bool {
        if(gestures.count == referenceGestures.count) {
            var correlated = true
            for index in 0...(gestures.count-1) {
                if(!(getCorrelation(gestures[index].xPoints, s2: referenceGestures[index].xPoints) > 0.85)
                    || !(getCorrelation(gestures[index].yPoints, s2: referenceGestures[index].yPoints) > 0.85)) {
                    correlated = false
                }
                print("gesture #", index)
                print(getCorrelation(gestures[index].xPoints, s2: referenceGestures[index].xPoints))
                print(getCorrelation(gestures[index].yPoints, s2: referenceGestures[index].yPoints))
            }
            if(correlated) {
                return true
            }
        }
        return false
    }
    
    private func unlock() {
        let pwd = "calmasino"
        let unlockScript = "tell application \"System Events\"\n if name of every process contains \"ScreenSaverEngine\" then\n tell application \"ScreenSaverEngine\"\n quit\n end tell\n end if\n set pword to \""+pwd+"\"\nrepeat 50 times\n tell application \"System Events\" to keystroke (ASCII character 8)\n end repeat\n tell application \"System Events\"\n keystroke pword\n keystroke return\n end tell\n end tell"
        
        let scriptObject = NSAppleScript(source: unlockScript)
        scriptObject?.executeAndReturnError(nil)
    }

}