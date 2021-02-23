//
//  ViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 18/02/21.
//

import UIKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var aulas = [(1, [("Algoritmos I", "Rodrigo Assirati"), ("Algoritmos I", "Rodrigo Assirati"), ("Algoritmos I", "Rodrigo Assirati"), ("Algoritmos I", "Rodrigo Assirati")]), (2, [("Pré-Calculo", "Adilson Konrad"), ("Pré-Calculo", "Adilson Konrad"), ("Pré-Calculo", "Adilson Konrad"), ("Pré-Calculo", "Adilson Konrad")])]
    
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
            print(date.dayNumberOfWeek() ?? 2)
    
            if date.dayNumberOfWeek()! == aulas[indexPath.row / 5].0 {
                myCell.backgroundColor = UIColor.init(red: 0.0, green: 70/255, blue: 135/255, alpha: 1)
                myCell.diaLbl.textColor = .white
            }
            
            
            myCell.diaLbl.text = diaDaSemana[aulas[indexPath.row / 5].0]
            
            myCell.accessibilityLabel = diaDaSemana[aulas[indexPath.row / 5].0]
            self.accessibilityElements?.append(myCell)
            
            return myCell
        }
        else {
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AulaCell", for: indexPath) as! AulaCell
            
            customCell.aulaLbl.text = aulas[indexPath.row / 5].1[mod - 1].0
            customCell.professorLbl.text = aulas[indexPath.row / 5].1[mod - 1].1
            
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

