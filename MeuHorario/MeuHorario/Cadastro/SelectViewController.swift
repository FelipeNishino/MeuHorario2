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

class SelectViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    
    weak var delegate : RegisterViewController?
    var senderIndex : Int?
    private var searchArguments : String = ""
    private var hasBothPeriods = false
    private let myTableView = UITableView()
    private let mySearchBar = UISearchBar()
    private let defaultTableCellHeight : CGFloat = 44.0
        
    private let fetchUtility = ContentViewCursos()
    private var cursos = [Curso]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    private var filteredCourses = [Curso]()
    
    private var horarios = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    private var horariosCategorizados = [[String]]()
    
    private var aulas = [Horario]()
    
    private var tableCategory : ContentType = .courses
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableCategory = ContentType(rawValue: senderIndex ?? 0) ?? .courses
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SelectionTableCell")
        myTableView.keyboardDismissMode = .onDrag
        
        mySearchBar.delegate = self
        mySearchBar.placeholder = "Pesquisar"
        
        if tableCategory == .courses {
            let sc = UISearchController(searchResultsController: nil)
            sc.hidesNavigationBarDuringPresentation = false
            sc.obscuresBackgroundDuringPresentation = false
            sc.searchBar.delegate = self
            sc.searchBar.placeholder = "Pesquisar"
            sc.showsSearchResultsController = true
            sc.searchBar.showsCancelButton = false
            self.navigationItem.searchController = sc
        }
        else {
            horariosCategorizados = [[],[]]
        }
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.view.addSubview(myTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        myTableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: self.view.frame.minY , width: self.view.frame.width - 2 * self.view.safeAreaInsets.right, height: self.view.frame.height)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableCategory != .courses {
            hasBothPeriods = horarios.contains(where: {$0.localizedCaseInsensitiveContains("Manhã")}) && horarios.contains(where: {$0.localizedCaseInsensitiveContains("Noite")})
            
            if hasBothPeriods {
                for period in horarios {
                    horariosCategorizados[period.localizedStandardContains("Manhã") ? 0 : 1].append(period)
                }
            }
            
            return horarios.contains(where: {$0.localizedCaseInsensitiveContains("Manhã")}) && horarios.contains(where: {$0.localizedCaseInsensitiveContains("Noite")}) ? 2 : 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableCategory == .periods ? (section == 0 ? "Manhã" : "Noite") : ""
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableCategory != .courses {
            return hasBothPeriods ? horariosCategorizados[(section == 0 ? 0 : 1)].count : horarios.count
        }
        filteredCourses = searchArguments != "" ? cursos.filter({curso in curso.nome.localizedCaseInsensitiveContains(searchArguments)}) : cursos
        
        return filteredCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableCell", for: indexPath)
        if tableCategory == .periods {
            myCell.textLabel?.text = hasBothPeriods ? horariosCategorizados[indexPath.section == 0 ? 0 : 1][indexPath.row] : horarios[indexPath.row]
        }
        else {
            myCell.textLabel!.text = filteredCourses[indexPath.row].nome
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
        delegate?.chosenValues[tableCategory.rawValue] = selectedValue
        delegate?.notifyReload(forCell: tableCategory.rawValue)
        delegate?.loadViewIfNeeded()
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArguments = searchText
        myTableView.reloadData()
    }
}
