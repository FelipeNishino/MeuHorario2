//
//  CadastroViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class RegisterViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    private let defaultTableCellHeight : CGFloat = 44.0
    private let myTableView = UITableView()
    
//    let button : UIButton = {
//        let btn = UIButton(frame: CGRect(x: 0, y: 500, width: 400, height: 20))
//        btn.setTitle("Set UserDefaults.didAlreadyLaunch to true", for: .normal)
//        btn.addTarget(self, action: #selector(setDict), for: .touchUpInside)
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = .purple
//        return btn
//    }()
    
    let titleLbl : UILabel = {
        let label = UILabel()
        label.text = "Qual o seu curso?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        label.textColor = UIColor(withHex: 0x004687)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLbl : UILabel = {
        let label = UILabel()
        label.text = "Insira o curso o qual você quer ver a grade horária.\nEssa informação pode ser alterada depois."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor(withHex: 0xc0c0c0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyTableCell")
        
        self.navigationController?.delegate = self
        
        self.view.addSubview(myTableView)
        view.addSubview(titleLbl)
        view.addSubview(descLbl)
//        view.addSubview(button)
        UserDefaults.didAlreadyLaunch = false
    }
    
    override func viewDidLayoutSubviews() {
        let safeAreaDimensions : (width : CGFloat, height : CGFloat) = (UIScreen.main.bounds.width - (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right), UIScreen.main.bounds.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom))
        
        myTableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: safeAreaDimensions.height / 2 , width: self.view.frame.width - 2 * self.view.safeAreaInsets.right, height: defaultTableCellHeight * 2)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vLbl]-20-[vTable]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vLbl" : titleLbl, "vTable" : myTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : titleLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-80-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func setDict() {
        UserDefaults.didAlreadyLaunch = true
        print("puts")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath)
        myCell.textLabel!.text = indexPath.row == 0 ? "Cursos" : "Semestres"
        myCell.accessoryType = .disclosureIndicator
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("puts tableview")
        let viewController = SelectViewController()
//        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
//        self.navController.pushViewController(viewController, animated: true)
    }
}
