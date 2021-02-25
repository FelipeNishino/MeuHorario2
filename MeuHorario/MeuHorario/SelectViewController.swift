//
//  SelecaoViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class SelectViewController : UIViewController, UINavigationControllerDelegate {
    let lbl : UILabel = {
        let label = UILabel()
        label.text = "Tela de Seleção"
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 200, width: 600, height: 40)
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(withHex: 0x004687)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Cursos"
        self.navigationController?.navigationBar.isHidden = false
        view.addSubview(lbl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.didAlreadyLaunch = true
    }
    
    override func viewDidLayoutSubviews() {
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|v0|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : lbl]))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|v0|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : lbl]))
    }
}
