//
//  ViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 18/02/21.
//

import UIKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var aulas = [("Segunda", ["Algoritmos I", "Algoritmos I", "Algoritmos I", "Algoritmos I"]), ("Terça", ["Pré-Cálculo", "Pré-Cálculo", "Pré-Cálculo", "Pré-Cálculo"])]
//    private var aulas : (String, [String])
    
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
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.register(AulaCell.self, forCellWithReuseIdentifier: "AulaCell")
        myCollectionView.backgroundColor = UIColor.white
        self.view.addSubview(myCollectionView)
        UserDefaults.didAlreadyLaunch = false
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
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
            myCell.backgroundColor = UIColor.blue
            return myCell
        }
        else {
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AulaCell", for: indexPath) as! AulaCell
            customCell.aulaLbl.text = aulas[indexPath.row / 5].1[mod - 1]
//            customCell.entradaLbl.accessibilityLabel = "Das 19:10 até 20:00"
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

