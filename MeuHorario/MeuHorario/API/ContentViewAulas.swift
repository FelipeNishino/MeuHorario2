//
//  ContentView.swift
//  MeuHorario
//
//  Created by Beatriz Gomes on 26/02/21.
//

import Foundation
import SwiftUI

struct ContentViewAulas: View {
    
    @State var results = [Horario]()
    
    func loadDataHorario() {
        guard let url = URL(string: "http://sistemasparainternet.azurewebsites.net/nasa/getHorarios.php?id=9") else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let response = try? JSONDecoder().decode(Aulas.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response.horarios
                        print(results)
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }.resume()
    }
    
    var body: some View {
        

        List(results, id: \.diaSemana) { item in
            VStack(alignment: .leading) {
                Text(item.disciplina)
                Text(item.professor)
                Text(item.faixaHoraria)

            }
        }.onAppear(perform: loadDataHorario)
    }
    
    
}

struct ContentViewAulas_Preview: PreviewProvider {
    static var previews: some View {
        ContentViewAulas()
    }
}
