//
//  UserDefaults+SafeReadWrite.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let didAlreadyLaunch = "didAlreadyLaunch"
        static let courseId = "courseId"
        static let semester = "semester"
    }
    
    class var didAlreadyLaunch : Bool {
        get {
            return standard.bool(forKey: Keys.didAlreadyLaunch)
        }
        set {
            standard.set(newValue, forKey: Keys.didAlreadyLaunch)
        }
    }
    
    class var courseId : String? {
        get {
            return standard.string(forKey: Keys.courseId)
        }
        set {
            standard.set(newValue, forKey: Keys.courseId)
        }
    }
    
    class var semester : String? {
        get {
            return standard.string(forKey: Keys.semester)
        }
        set {
            standard.set(newValue, forKey: Keys.semester)
        }
    }
    
//    static private func inRange(value: Int, range: ClosedRange<Int>) -> Bool {
//        range ~= value
//    }
//
//    static private func inRange(value: Int, range: ClosedRange<Int>, do action: () -> Void) {
//        if range ~= value {
//            action()
//        }
//    }
    
//    static func setApplicationDefault() {
//        UserDefaults.didAlreadyLaunch = false
//    }
}
