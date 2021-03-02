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
    private var auxArray = [String]()
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
    private var horariosCategorizados = [[(original: String, manip: String)]]()
    
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
                    let sectionIndex = period.localizedStandardContains("Manhã") ? 0 : 1
                    horariosCategorizados[sectionIndex].append((original: period, manip: ""))
                    let rowIndex = horariosCategorizados[sectionIndex].count - 1
                    var auxStr = ""
                    for word in horariosCategorizados[sectionIndex][rowIndex].original.split(separator: " ") {
                        if !auxStr.isEmpty {
                            auxStr.append(" ")
                        }
                        auxStr.insert(contentsOf: (word.contains("Sem") ? "Semestre" : word), at:auxStr.endIndex)
                    }
                    horariosCategorizados[sectionIndex][rowIndex].original = auxStr
                }
            }
            else {
                auxArray = []
                for period in horarios {
                    var auxStr = ""
                    for word in period.split(separator: " ") {
                        if !auxStr.isEmpty {
                            auxStr.append(" ")
                        }
                        auxStr.insert(contentsOf: (word.contains("Sem") ? "Semestre" : word), at:auxStr.endIndex)
                        print(auxStr)
                    }
                    auxArray.append(auxStr)
                }
            }
            return hasBothPeriods ? 2 : 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // TODO: Colocar o header certo para quando só existe um período
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
            if hasBothPeriods {
                for word in horariosCategorizados[indexPath.section][indexPath.row].original.split(separator: " ") {
                    if !horariosCategorizados[indexPath.section][indexPath.row].manip.isEmpty {
                        horariosCategorizados[indexPath.section][indexPath.row].manip.append(" ")
                    }
                    if !word.contains("Manhã") && !word.contains("Noite") {
                        horariosCategorizados[indexPath.section][indexPath.row].manip.insert(contentsOf: word, at: horariosCategorizados[indexPath.section][indexPath.row].manip.endIndex)
                    }
                }
                myCell.textLabel?.text = horariosCategorizados[indexPath.section][indexPath.row].manip
            }
            else {
                myCell.textLabel?.text = auxArray[indexPath.row]
            }
        }
        else {
            myCell.textLabel!.text = filteredCourses[indexPath.row].nome
        }
        
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableCategory == .courses {
            let selectedValue = tableView.cellForRow(at: indexPath)?.textLabel?.text
            delegate?.chosenValues[1] = nil
            //            delegate?.notifyReload(forCell: 1)
            delegate?.chosenCourse = cursos.first(where: {curso in curso.nome == selectedValue})
        }
        else {
            delegate?.chosenValues[tableCategory.rawValue] = hasBothPeriods ? horariosCategorizados[indexPath.section][indexPath.row].original : auxArray[indexPath.row]
        }
        delegate?.notifyReload(forCell: tableCategory.rawValue)
        delegate?.loadViewIfNeeded()
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArguments = searchText
        myTableView.reloadData()
    }
}
