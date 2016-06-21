//
//  AppData.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 28/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class AppData: NSObject, NSCoding {
    //variables initialization
    var sequence : [Gesture]?
    var password : NSString?
    var gestureTime : NSNumber?
    var launchAtLogin : Bool?
    
    init?(sequence: [Gesture]?, password: NSString?, gestureTime: NSNumber?, launchAtLogin: Bool?) {
        // Initialize stored properties.
        self.sequence = sequence
        self.password = password
        self.gestureTime = gestureTime
        self.launchAtLogin = launchAtLogin
        
        super.init()
    }
    
    override init() {
        // Initialize stored properties.
        self.sequence = nil
        self.password = nil
        self.gestureTime = nil
        self.launchAtLogin = nil
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(sequence, forKey: PropertyKeyAppData.sequenceKey)
        aCoder.encodeObject(password, forKey: PropertyKeyAppData.passwordKey)
        aCoder.encodeObject(gestureTime, forKey: PropertyKeyAppData.gestureTimeKey)
        aCoder.encodeObject(launchAtLogin, forKey: PropertyKeyAppData.launchAtLoginKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeObjectForKey(PropertyKeyAppData.sequenceKey) as? [Gesture]
        let password = aDecoder.decodeObjectForKey(PropertyKeyAppData.passwordKey) as? NSString
        let gestureTime = aDecoder.decodeObjectForKey(PropertyKeyAppData.gestureTimeKey) as? NSNumber
        let launchAtLogin = aDecoder.decodeObjectForKey(PropertyKeyAppData.launchAtLoginKey) as? Bool
        
        self.init(sequence: sequence, password: password, gestureTime: gestureTime, launchAtLogin: launchAtLogin)
    }
}

struct PropertyKeyAppData {
    static let sequenceKey = "sequence"
    static let passwordKey = "password"
    static let gestureTimeKey = "gestureTime"
    static let launchAtLoginKey = "launchAtLogin"
}