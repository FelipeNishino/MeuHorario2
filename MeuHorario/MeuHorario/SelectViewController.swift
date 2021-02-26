//
//  SelecaoViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 23/02/21.
//

import UIKit

enum ContentType : Int {
    case courses
    case periods
}

class SelectViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    weak var delegate : RegisterViewController?
    var senderIndex : Int?
    
    private let myTableView = UITableView()
    private let defaultTableCellHeight : CGFloat = 44.0
    
    private let dados = [["BCC", "BSI", "TADS"], ["primeiro", "segundo", "terceiro", "quarto", "quinto", "sexto"]]
    
//    private let cursos = ["BCC", "BSI", "TADS"]
//    private let semestres = ["primeiro", "segundo", "terceiro", "quarto", "quinto", "sexto"]
    private var tableCategory : ContentType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SelectionTableCell")
        
        self.navigationController?.delegate = self
        
        self.view.addSubview(myTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableCategory = ContentType(rawValue: senderIndex ?? 0)
        self.navigationController?.navigationBar.topItem?.title = self.tableCategory == .courses ? "Cursos" : "Semestres"
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        myTableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.view.safeAreaInsets.top , width: self.view.frame.width - 2 * self.view.safeAreaInsets.right, height: self.view.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        UserDefaults.didAlreadyLaunch = true
    }
    
    override func viewDidLayoutSubviews() {
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|v0|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : lbl]))
//        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|v0|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : lbl]))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados[tableCategory?.rawValue ?? 0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableCell", for: indexPath)
        myCell.textLabel!.text = dados[tableCategory?.rawValue ?? 0][indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableCategory == .courses {
            delegate?.chosenValues[1] = nil
            delegate?.notifyReload(forCell: 1)
        }
        delegate?.chosenValues[tableCategory?.rawValue ?? 0] = tableView.cellForRow(at: indexPath)?.textLabel?.text
        delegate?.notifyReload(forCell: tableCategory?.rawValue ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
}
