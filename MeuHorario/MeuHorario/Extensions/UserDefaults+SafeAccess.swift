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
        static let arrayTuplas = "arrayTuplas"
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
    
    class var arrayTuplas : [Horario]? {
        get {
            if let data = UserDefaults.standard.value(forKey: Keys.arrayTuplas) as? Data {
                do {
                    let horarios = try PropertyListDecoder().decode(Array<Horario>.self, from: data)
                    return horarios
                }
                catch {
                    return nil
                }
            }
            return nil
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.arrayTuplas)
        }
    }
    
}
