//
//  Dates.swift
//  MeuHorario
//
//  Created by Lucas Claro on 23/02/21.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
}
