//
//  WrapperViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class WrapperViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        let lbl = UILabel()
        lbl.text = "Wrapper"
        lbl.textColor = .green
        lbl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lbl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.didAlreadyLaunch {
            let viewController = ViewController()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
        else {
            let viewController = RegisterViewController()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
}
