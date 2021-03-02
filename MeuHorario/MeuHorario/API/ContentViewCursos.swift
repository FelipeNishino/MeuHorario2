//
//  ContentView.swift
//  MeuHorario
//
//  Created by Beatriz Gomes on 26/02/21.
//

import Foundation

class ContentViewCursos {
    
    var resultsCursos = [Curso]()
    var resultsHorarios = [Horario]()
    
    func loadDataCursos(completionHandler: @escaping ([Curso]) -> Void) {
        guard let url = URL(string: "http://sistemasparainternet.azurewebsites.net/nasa/getCursos.php") else {
//            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.resultsCursos = response.cursos
                        completionHandler(self.resultsCursos)
                    }
                    return
                }
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }.resume()
    }
    
    func loadDataHorario(courseId id: String ,completionHandler: @escaping ([Horario]) -> Void) {
        guard let url = URL(string: "http://sistemasparainternet.azurewebsites.net/nasa/getHorarios.php?id=\(id)") else {
//            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let response = try? JSONDecoder().decode(Aulas.self, from: data) {
                    DispatchQueue.main.async {
                        self.resultsHorarios = response.horarios
                        completionHandler(self.resultsHorarios)
//                        print(resultsHorarios)
                    }
                    return
                }
//                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }.resume()
    }
    
//    var body: some View {
//
//
//        List(results, id: \.id) { item in
//            VStack(alignment: .leading) {
//                Text(item.nome)
//            }
//        }.onAppear(perform: loadDataCursos)
//    }
//
    
}
