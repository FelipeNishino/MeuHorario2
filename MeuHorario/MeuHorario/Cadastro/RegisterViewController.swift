//
//  CadastroViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

class RegisterViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var needsReload : (control : Bool, at: Set<Int>) = (false, [])
    var shouldReload : Bool = false
    
    private let defaultTableCellHeight : CGFloat = 44.0
    private let myTableView = UITableView()
    
    var chosenValues : [String?] = [nil, nil]
    var chosenCourse : Curso? = nil {
        didSet {
            if chosenCourse != nil {
                notifyReload(forCell: 1)
            }
        }
    }
    
    private var shownCellsCount = 2
    
    private var tableViewHeight : CGFloat = 44.0
    
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
    
    private let continueBtn : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("Continuar", for: .normal)
        btn.setTitleColor(UIColor(named: "pb"), for: .normal)
        btn.backgroundColor = UIColor(named: "Cabecalho")
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(finish), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegisterTableCell")
        myTableView.isScrollEnabled = false
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.backgroundColor = self.view.backgroundColor
        
        self.navigationController?.delegate = self
        
        
        
        self.view.addSubview(myTableView)
        self.view.addSubview(titleLbl)
        self.view.addSubview(descLbl)
        self.view.addSubview(continueBtn)
    }
    
    override func viewDidLayoutSubviews() {
        let safeAreaDimensions : (width : CGFloat, height : CGFloat) = (UIScreen.main.bounds.width - (self.view.safeAreaInsets.left + self.view.safeAreaInsets.right), UIScreen.main.bounds.height - (self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom))
        
        myTableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: safeAreaDimensions.height / 2 , width: self.view.frame.width - 2 * self.view.safeAreaInsets.right, height: defaultTableCellHeight * 2)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(safeAreaDimensions.height / 2 - tableViewHeight)-[v0(\(tableViewHeight * 2))]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : myTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : myTableView]))
//
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vTable]-70-[vButton]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vTable" : myTableView, "vButton" : continueBtn]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(safeAreaDimensions.width * 0.32)-[v0]-\(safeAreaDimensions.width * 0.32)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : continueBtn]))
//
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[vLbl]-20-[vTable]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["vLbl" : titleLbl, "vTable" : myTableView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : titleLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-80-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : descLbl]))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("willAppear")
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = !UserDefaults.didAlreadyLaunch
        
        if chosenValues[1] != nil {
            continueBtn.isHidden = false
        }
        if chosenCourse != nil && myTableView.visibleCells.count == 1 {
            myTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }

        self.view.backgroundColor = UIColor(named: "Fundo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("didAppear")
        if needsReload.control {
            print("Tries to reload")
            while !needsReload.at.isEmpty {
                updateCell(index: needsReload.at.popFirst()!)
            }
            needsReload.control = false
            print("Reload done")
        }
//        if chosenCourse == nil {
//            myTableView.performBatchUpdates({ shownCellsCount -= 1 ; myTableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic) ;myTableView.reloadData()}, completion: {didcomplete in print(didcomplete ? "deletion successful" : "deletion unsuccessful")})
//        }
//        else {
//            myTableView.performBatchUpdates({ shownCellsCount += 1 ; myTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic) ;myTableView.reloadData()}, completion: {didcomplete in print(didcomplete ? "insertion successful" : "insertion unsuccessful")})
//        }
    }
    
    @objc func finish() {
        UserDefaults.courseId = chosenCourse?.id
        UserDefaults.semester = chosenValues[1]
        UserDefaults.didAlreadyLaunch = true
        
        print("puts botao")
        
        self.navigationController?.navigationBar.isHidden = true
        self.dismiss(animated: false, completion: {print("dismiss vc")})
    }
    
    func notifyReload(forCell index: Int) {
        needsReload.control = true
        needsReload.at.insert(index)
    }
    
    func updateCell(index: Int) {
        myTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("trying to load tableView with \(chosenCourse == nil ? 1 : 2) cells")
        return chosenCourse == nil ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableCell", for: indexPath)
        myCell.textLabel!.text = indexPath.row == 0 ? chosenCourse?.nome ?? "Cursos" : chosenValues[1] ?? "Semestres"
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
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}