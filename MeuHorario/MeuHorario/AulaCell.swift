//
//  customCell.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 22/02/21.
//

import UIKit

class AulaCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let aulaLbl : UILabel = {
        let label = UILabel()
        label.text = "Custom Text"
        label.accessibilityLabel = "Custom Text"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let professorLbl : UILabel = {
        let label = UILabel()
        label.text = "Thyago Quintas"
        label.accessibilityLabel = "Thyago Quintas"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let entradaLbl : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saidaLbl : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let vr : UIView = {
        let separator = UIView()
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .black
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    func setupViews() {
        backgroundColor = UIColor.red
        addSubview(aulaLbl)
        addSubview(professorLbl)
        addSubview(entradaLbl)
        addSubview(saidaLbl)
        addSubview(vr)
        
        self.contentView.accessibilityElements = [self.aulaLbl, self.professorLbl, self.entradaLbl]
//        addSubview(<vr>)
        
//        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.4).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : entradaLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : saidaLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[vEntrada]-12-[vSaida]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vEntrada" : entradaLbl, "vSaida" : saidaLbl]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-72-[vr]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vr" : vr]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vr]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vr" : vr]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-86-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : aulaLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-86-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : professorLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[vAula]-8-[vProf]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vAula" : aulaLbl, "vProf" : professorLbl]))
    }
}
