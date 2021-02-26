//
//  CadastroViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class RegisterViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var needsReload : (control : Bool, at: Set<Int>) = (false, [])
    private let defaultTableCellHeight : CGFloat = 44.0
    private let myTableView = UITableView()
    
    var chosenValues : [String?] = [nil, nil]
    
    private let titleLbl : UILabel = {
        let label = UILabel()
        label.text = "Qual o seu curso?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
//        label.textColor = UIColor(withHex: 0x004687)
        label.textColor = UIColor(named: "Cabecalho")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descLbl : UILabel = {
        let label = UILabel()
        label.text = "Insira o curso o qual você quer ver a grade horária.\nEssa informação pode ser alterada depois."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
//        label.textColor = UIColor(withHex: 0xc0c0c0)
        label.textColor = UIColor(named: "CizaTexto")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegisterTableCell")
        
        self.navigationController?.delegate = self
        
        self.view.addSubview(myTableView)
        view.addSubview(titleLbl)
        view.addSubview(descLbl)
    }
    
    override func viewDidLayoutSubviews() {
        let safeAreaDimensions : (width : CGFloat, height : CGFloat) = (UIScreen.main.bounds.width - (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right), UIScreen.main.bounds.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom))
        
        myTableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: safeAreaDimensions.height / 2 , width: self.view.frame.width - 2 * self.view.safeAreaInsets.right, height: defaultTableCellHeight * (chosenValues[0] != nil ? 2 : 1))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vLbl]-20-[vTable]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vLbl" : titleLbl, "vTable" : myTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : titleLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-80-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.backgroundColor = UIColor(named: "Fundo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if needsReload.control {
            while !needsReload.at.isEmpty {
                updateCell(index: needsReload.at.popFirst()!)
            }
            needsReload.control = false
        }
    }
    
    func notifyReload(forCell index: Int) {
        needsReload.control = true
        needsReload.at.insert(index)
    }
    
    func updateCell(index: Int) {
        myTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableCell", for: indexPath)
        myCell.textLabel!.text = indexPath.row == 0 ? chosenValues[0] ?? "Cursos" : chosenValues[1] ?? "Semestres"
        myCell.accessoryType = .disclosureIndicator
        
        myCell.backgroundColor = UIColor(named: "Fundo")
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("puts tableview")
        let viewController = SelectViewController()
        viewController.delegate = self
        viewController.senderIndex = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
