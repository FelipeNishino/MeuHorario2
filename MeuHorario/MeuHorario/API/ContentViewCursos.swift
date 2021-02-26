//
//  ContentView.swift
//  MeuHorario
//
//  Created by Beatriz Gomes on 26/02/21.
//

import Foundation
import SwiftUI

struct ContentViewCursos: View {
    
    @State var results = [Curso]()
    
    func loadDataCursos() {
        guard let url = URL(string: "http://sistemasparainternet.azurewebsites.net/nasa/getCursos.php") else {
            print("Your API end point is Invalid")
            return
        }
        let request = URLRequest(url: url)

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = response.cursos
                        print(results)
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                
            }
        }.resume()
    }
    
    var body: some View {
        

        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(item.nome)
            }
        }.onAppear(perform: loadDataCursos)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewCursos()
    }
}
