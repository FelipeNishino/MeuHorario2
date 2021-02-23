//
//  DiaCell.swift
//  MeuHorario
//
//  Created by Lucas Claro on 23/02/21.
//

import UIKit

class DiaCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let diaLbl : UILabel = {
        let label = UILabel()
        label.text = "Dia"
        label.textColor = UIColor.white
        label.font = .systemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.init(red: 0.0, green: 70/255, blue: 135/255, alpha: 1)
        addSubview(diaLbl)
        
        self.accessibilityLabel = "Dia da semana"
        self.isAccessibilityElement = true
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : diaLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : diaLbl]))
        
    }
}
