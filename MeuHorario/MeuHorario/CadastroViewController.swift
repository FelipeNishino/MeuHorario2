//
//  CadastroViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class CadastroViewController : UIViewController {
    let button : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 40))
        btn.setTitle("Set UserDefaults.didAlreadyLaunch to true", for: .normal)
        btn.addTarget(self, action: #selector(setDict), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .purple
        return btn
    }()
    
    let titleLbl : UILabel = {
        let label = UILabel()
        label.text = "Qual o seu curso?"
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLbl : UILabel = {
        let label = UILabel()
        label.text = "Insira o curso o qual você quer ver a grade horária?"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func setDict() {
        UserDefaults.didAlreadyLaunch = true
        print("puts")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        view.addSubview(button)
    }
}
