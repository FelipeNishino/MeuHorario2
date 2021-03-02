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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        present(createController(controllerType: UserDefaults.didAlreadyLaunch ? ViewController() : RegisterViewController()), animated: false, completion: nil)
    }

    func createController<T : UIViewController>(controllerType vc: T) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.isHidden = true
        navController.navigationController?.navigationBar.prefersLargeTitles = true
        navController.navigationItem.largeTitleDisplayMode = .always
        return navController
    }
}
