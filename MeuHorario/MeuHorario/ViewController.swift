//
//  ViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 18/02/21.
//

import UIKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var aulas = [
                        (1, [("Algoritmos I", "Rodrigo Assirati", "19h10", "20h00"), ("Algoritmos I", "Rodrigo Assirati", "20h00", "20h50"), ("Algoritmos I", "Rodrigo Assirati", "21h05", "21h55"), ("Algoritmos I", "Rodrigo Assirati", "21h55", "22h45")]),
                        (2, [("Pré-Calculo", "Adilson Konrad", "19h10", "20h00"),("Pré-Calculo", "Adilson Konrad", "20h00", "20h50"),("Introdução a Computação", "Thyago Quintas", "21h05", "21h55"),("Introdução a Computação", "Thyago Quintas", "21h55", "22h45")]),
                        (3, [("Programação Web", "Fábio Abenza", "19h10", "20h00"),("Banco de Dados", "Thiago Claro", "20h00", "20h50"), ("Programação Web", "Fábio Abenza", "21h05", "20h55"),("Banco de Dados", "Thiago Claro", "21h55", "22h45")])
                         
                        ]
    
    private var diaDaSemana = [1 : "Segunda-Feira", 2 : "Terça-Feira", 3 : "Quarta-Feira", 4 : "Quinta-Feira", 5 : "Sexta-Feira", 6 : "Sábado"]
    
    private let horizontalEdgeInsets : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: horizontalEdgeInsets / 2, bottom: 10, right: horizontalEdgeInsets / 2)
//        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - horizontalEdgeInsets, height: 60)
        
        let myCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.accessibilityTraits = .adjustable
        
        myCollectionView.register(DiaCell.self, forCellWithReuseIdentifier: "DiaCell")
        myCollectionView.register(AulaCell.self, forCellWithReuseIdentifier: "AulaCell")
        
        myCollectionView.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.view.addSubview(myCollectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row % 5 == 0 ? CGSize(width: UIScreen.main.bounds.width - horizontalEdgeInsets, height: 40) : CGSize(width: UIScreen.main.bounds.width - horizontalEdgeInsets, height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aulas.count * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mod = indexPath.row % 5
        
        if mod == 0 {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaCell", for: indexPath) as! DiaCell
            
            let date = Date()
    
            if date.dayNumberOfWeek()! == aulas[indexPath.row / 5].0 {
                myCell.backgroundColor = UIColor.init(red: 0.0, green: 70/255, blue: 135/255, alpha: 1)
                myCell.diaLbl.textColor = .white
            }
            
            
            myCell.diaLbl.text = diaDaSemana[aulas[indexPath.row / 5].0]
            
            myCell.accessibilityLabel = diaDaSemana[aulas[indexPath.row / 5].0]
            self.accessibilityElements?.append(myCell)
            
            print("----------")
            
            return myCell
        }
        else {
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AulaCell", for: indexPath) as! AulaCell
            
            customCell.aulaLbl.text = aulas[indexPath.row / 5].1[mod - 1].0
            customCell.professorLbl.text = aulas[indexPath.row / 5].1[mod - 1].1
            customCell.entradaLbl.text = aulas[indexPath.row / 5].1[mod - 1].2
            customCell.saidaLbl.text = aulas[indexPath.row / 5].1[mod - 1].3
            
            var x = 0///Guarda quantas aulas iguais seguidas tem pela frente
            var continuo = true///Evita que duas aulas iguais n seguidas quebrem o código
            
            ////Vê se a aula anterior é igual a mim, a não ser que seja a primeira aula
            if mod > 1 && aulas[indexPath.row / 5].1[mod - 1].0 == aulas[indexPath.row / 5].1[mod - 2].0 && aulas[indexPath.row / 5].1[mod - 1].1 == aulas[indexPath.row / 5].1[mod - 2].1 {
                print("oi")//Aqui eu tenho que tornar a cell n acessível
            }
            else{
                ////Percorre as aulas que vêm depois de mim
                for i in (1...3) {
                    ////Vê se a próxima aula ainda é igual a mim, a não ser que seja a última aula
                    if mod + i <= 4 && continuo && aulas[indexPath.row / 5].1[mod - 1].0 == aulas[indexPath.row / 5].1[mod - 1 + i].0 && aulas[indexPath.row / 5].1[mod - 1].1 == aulas[indexPath.row / 5].1[mod - 1 + i].1 {
                        x = i
                    }
                    else {
                        continuo = false
                    }
                }
                print("a \(x)")//Aqui eu tenho que trocar o horário de saída que será lido pelo VoiceOver
            }
            
            
            self.accessibilityElements?.append(customCell)
            return customCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

