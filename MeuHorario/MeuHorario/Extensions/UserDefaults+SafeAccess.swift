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
        static let courseName = "courseName"
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
    
    class var courseName : String? {
        get {
            return standard.string(forKey: Keys.courseName)
        }
        set {
            standard.set(newValue, forKey: Keys.courseName)
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
    
}
