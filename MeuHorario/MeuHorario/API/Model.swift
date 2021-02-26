//
//  Model.swift
//  MeuHorario
//
//  Created by Beatriz Gomes on 25/02/21.
//

import Foundation

// MARK: - Response Cursos
struct Response: Codable {
    let response: String
    let cursos: [Curso]
}

// MARK: - Curso
struct Curso: Codable {
    let id, nome: String
}

// MARK: - Response Aulas
struct Aulas: Codable {
    let response: String
    let horarios: [Horario]
}

// MARK: - Horario
struct Horario: Codable {
    let diaSemana, faixaHoraria, disciplina, professor: String
    let sala, turma, semestre, curso: String

    enum CodingKeys: String, CodingKey {
        case diaSemana = "DiaSemana"
        case faixaHoraria
        case disciplina = "Disciplina"
        case professor = "Professor"
        case sala
        case turma = "Turma"
        case semestre = "Semestre"
        case curso = "Curso"
    }
}
