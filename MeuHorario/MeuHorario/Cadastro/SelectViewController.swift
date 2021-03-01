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
    
    private let fetchUtility = ContentViewCursos()
    private var cursos = [Curso]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    private var horarios = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    private var aulas = [Horario]()
    
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
        
        if tableCategory == .courses {
            fetchUtility.loadDataCursos { cursosArray in
                self.cursos = cursosArray
            }
        }
        else {
            fetchUtility.loadDataHorario(courseId: delegate?.chosenCourse?.id ?? "1") { horariosArray in
                var auxSet = Set<String>()
                horariosArray.forEach { horario in
                    auxSet.insert(horario.semestre)
                }
                self.horarios = auxSet.compactMap({$0}).sorted()
            }
        }
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
        if tableCategory != .courses {
            return horarios.count
        }
        
        return cursos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableCell", for: indexPath)
        if tableCategory == .periods {
            myCell.textLabel!.text = horarios[indexPath.row]
        }
        else {
            myCell.textLabel!.text = cursos[indexPath.row].nome
        }

        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        if tableCategory == .courses {            
            delegate?.chosenValues[1] = nil
//            delegate?.notifyReload(forCell: 1)
            delegate?.chosenCourse = cursos.first(where: {curso in curso.nome == selectedValue})
        }
        delegate?.chosenValues[tableCategory?.rawValue ?? 0] = selectedValue
        delegate?.notifyReload(forCell: tableCategory?.rawValue ?? 0)
        delegate?.loadViewIfNeeded()
        self.navigationController?.popViewController(animated: true)
    }
}
