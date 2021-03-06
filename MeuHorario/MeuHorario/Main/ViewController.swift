//
//  ViewController.swift
//  MeuHorario
//
//  Created by Felipe Nishino on 18/02/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let fetchUtility = ContentViewCursos()
    
    private var myCollectionView : UICollectionView!
    
    //MARK: AulasDidSet
    private var aulasFull = [Horario](){
        didSet{
            
            var auxSet = Set<String>()
            var diasShiftados : Set = ["1", "2", "3", "4", "5", "6"]
            
            for aula in aulasFull {
                auxSet.insert(aula.diaSemana)
                if aula.faixaHoraria == "08h - 08h50"{
                    diasShiftados.remove(aula.diaSemana)
                }
            }

            let set = auxSet.sorted()
            
                aulas = []

                for dia in set {
                    var tupla : (Int, [(String, String, String, String)])
                    var vetorModelo : [(String, String, String, String)]
//                    var vetor = [(String, String, String, String)]()

                    if aulasFull[0].semestre.contains("Manhã") || dia == "6"{
                        if diasShiftados.contains(dia) {
                            vetorModelo = [("", "", "08h50", "09h40"), ("", "", "09h55", "10h45"), ("", "", "10h45", "11h35"), ("", "", "11h35", "12h25")]
                        } else {
                            vetorModelo = [("", "", "08h", "08h50"), ("", "", "08h50", "09h40"), ("", "", "09h55", "10h45"), ("", "", "10h45", "11h35")]
                        }
                    }
                    else {
                        vetorModelo = [("", "", "19h10", "20h00"), ("", "", "20h00", "20h50"), ("", "", "21h05", "21h55"), ("", "", "21h55", "22h45")]

                    }

                    for aula in aulasFull {
                        if aula.diaSemana == dia {
                            
                            let IO = aula.faixaHoraria.components(separatedBy: " - ")
                            var qUpla : (String, String, String, String)
                            qUpla = (aula.disciplina, aula.professor, IO[0], IO[1])
                            for i in (0...3){
                                if vetorModelo[i].2 == qUpla.2 {
                                    vetorModelo[i] = qUpla
                                }
                            }
                        }
                    }

                    tupla = (Int(dia)!, vetorModelo)

                    aulas.append(tupla)

                }
            
            UserDefaults.arrayTuplas = aulasFull
            
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
    }
    
    private var aulas = [(Int, [(String, String, String, String)])]()
    
    private var aulasTeste = [
                        (1, [("Algoritmos I", "Thiago C.", "19h10", "20h00"), ("Algoritmos I", "Thiago C.", "20h00", "20h50"), ("Algoritmos I", "Thiago C.", "21h05", "21h55"), ("Algoritmos I", "Thiago C.", "21h55", "22h45")]),
                        (2, [("Aplicações Interativas ", "Fábio A.", "21h05", "21h55"),("Aplicações Interativas", "Fábio A.", "21h55", "22h45"),("Aplicações Interativas ", "Fábio A.", "21h05", "21h55"),("Aplicações Interativas", "Fábio A.", "21h55", "22h45")]),
                        (3, [("Programação Web", "Fábio Abenza", "19h10", "20h00"),("Banco de Dados", "Thiago Claro", "20h00", "20h50"), ("Programação Web", "Fábio Abenza", "21h05", "20h55"),("Banco de Dados", "Thiago Claro", "21h55", "22h45")]),
                        (4, [("Programação Web", "Fábio Abenza", "19h10", "20h00"),("Banco de Dados", "Thiago Claro", "20h00", "20h50"), ("Programação Web", "Fábio Abenza", "21h05", "20h55"),("Banco de Dados", "Thiago Claro", "21h55", "22h45")])
                        ]
    
    private var diaDaSemana = [1 : "Segunda-Feira", 2 : "Terça-Feira", 3 : "Quarta-Feira", 4 : "Quinta-Feira", 5 : "Sexta-Feira", 6 : "Sábado"]
    
    private var horarios = ["19h10" : "Desenove e dez", "20h00" : "Vinte", "20h50" : "Vinte e cinquenta", "21h05" : "Vinte uma e cinco",
                            "21h55" : "Vinte uma e cinquenta e cinco", "22h45" : "Vinte duas e quarenta e cinco",
                            "08h": "Oito", "08h50" : "Oito e cinquenta", "09h40" : "Nove e quarenta", "09h55" : "Nove e cinquenta e cinco",
                            "10h45" : "Dez e quarenta e cinco", "11h35" : "Onze e cinquenta e cinco", "12h25" : "Meio dia e vinte e cinco"]
    
    private let horizontalEdgeInsets : CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    MARK: ViewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.arrayTuplas == nil {
            fetchUtility.loadDataHorario(courseId: UserDefaults.courseId ?? "1") { horariosArray in
                var horarios = [Horario]()
                horariosArray.forEach { horario in
                    let str = UserDefaults.semester
                    var auxStr = str
                    auxStr?.replaceSubrange((str?.firstIndex(of: "S"))!...(str?.index((str?.firstIndex(of: "S"))!, offsetBy: 8))!, with: "Sem ")
                    if horario.semestre == auxStr {
                        horarios.append(horario)
                    }
                }
                self.aulasFull = horarios
            }
        }
        else {
            self.aulasFull = UserDefaults.arrayTuplas!
        }
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: horizontalEdgeInsets / 2, bottom: 10, right: horizontalEdgeInsets / 2)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        myCollectionView.frame = self.view.frame
//        myCollectionView.collectionViewLayout = layout
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        myCollectionView.accessibilityTraits = .adjustable
        
        myCollectionView.register(DiaCell.self, forCellWithReuseIdentifier: "DiaCell")
        myCollectionView.register(AulaCell.self, forCellWithReuseIdentifier: "AulaCell")
        
        
        let configButton : UIBarButtonItem = {
            let btn = UIBarButtonItem(image: UIImage(systemName: "wrench.and.screwdriver"), style: .plain, target: self, action: #selector(changeCourse))
            btn.action = #selector(changeCourse)
            btn.accessibilityLabel = "Alterar Curso e Semestre"
            btn.tintColor = UIColor(named: "cabecalho")
            return btn
        }()
        
        self.navigationItem.title = UserDefaults.courseName
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = configButton
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .always
        
        myCollectionView.backgroundColor = UIColor(named: "Fundo")
        self.view.addSubview(myCollectionView)
    }
    
    @objc func changeCourse() {
        let rvc = RegisterViewController()
        
        let courseName = UserDefaults.courseName?.description ?? String();
        rvc.chosenCourse = Curso(id: UserDefaults.courseId!, nome: courseName)
        
        rvc.chosenSemester = UserDefaults.semester!
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
//    MARK: CellsSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row % 5 == 0 ? CGSize(width: UIScreen.main.bounds.width - horizontalEdgeInsets, height: 40) : CGSize(width: UIScreen.main.bounds.width - horizontalEdgeInsets, height: 82)
    }
    
//    MARK: CellsNuber
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aulas.count * 5
    }
    
//    MARK: Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mod = indexPath.row % 5
        
        if mod == 0 {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaCell", for: indexPath) as! DiaCell
            
            let date = Date()
    
            myCell.backgroundColor = .clear
            myCell.diaLbl.textColor = .label
            
            ////Pinta de azul o dia atual
            if date.dayNumberOfWeek()! == aulas[indexPath.row / 5].0 {
//                myCell.backgroundColor = UIColor.init(red: 0.0, green: 70/255, blue: 135/255, alpha: 1)
                myCell.backgroundColor = UIColor(named: "Cabecalho")
                myCell.diaLbl.textColor = UIColor(named: "pb")
            }
            
            
            myCell.diaLbl.text = diaDaSemana[aulas[indexPath.row / 5].0]
            
            myCell.accessibilityLabel = diaDaSemana[aulas[indexPath.row / 5].0]
            self.accessibilityElements?.append(myCell)
            
            return myCell
        }
        
        else {
            let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AulaCell", for: indexPath) as! AulaCell
            
            customCell.aulaLbl.text = aulas[indexPath.row / 5].1[mod - 1].0
            customCell.professorLbl.text = aulas[indexPath.row / 5].1[mod - 1].1
            customCell.entradaLbl.text = aulas[indexPath.row / 5].1[mod - 1].2
            customCell.saidaLbl.text = aulas[indexPath.row / 5].1[mod - 1].3
            
            var x = 0///Guarda quantas aulas iguais seguidas tem pela frente
            var continuo = true///Evita que duas aulas iguais n seguidas quebrem o código
            
            ////Vê se a aula anterior é igual a mim, a não ser que seja a primeira aula
            if aulas[indexPath.row / 5].1[mod - 1].0 == "" || (mod > 1 && aulas[indexPath.row / 5].1[mod - 1].0 == aulas[indexPath.row / 5].1[mod - 2].0 && aulas[indexPath.row / 5].1[mod - 1].1 == aulas[indexPath.row / 5].1[mod - 2].1) {
                customCell.isAccessibilityElement = false
            }
            else{
                ////Percorre as aulas que vêm depois de mim
                for i in (1...3) {
                    ////Vê se a próxima aula ainda é igual a mim, a não ser que seja a última aula
                    if mod + i <= 4 && continuo && aulas[indexPath.row / 5].1[mod - 1].0 == aulas[indexPath.row / 5].1[mod - 1 + i].0 && aulas[indexPath.row / 5].1[mod - 1].1 == aulas[indexPath.row / 5].1[mod - 1 + i].1 {
                        x = i
                    }
                    else {
                        continuo = false
                    }
                }
                customCell.isAccessibilityElement = true
                customCell.accessibilityLabel = "\(aulas[indexPath.row / 5].1[mod - 1].0) com \(aulas[indexPath.row / 5].1[mod - 1].1) das \(aulas[indexPath.row / 5].1[mod - 1].2) até \(aulas[indexPath.row / 5].1[mod - 1 + x].3)"
            }
            
            
            self.accessibilityElements?.append(customCell)
            return customCell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

