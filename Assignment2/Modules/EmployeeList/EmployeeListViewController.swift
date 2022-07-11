//
//  EmployeeListViewController.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EmployeeListViewController: UIViewController {

    lazy var tableView : UITableView = {
        let tblView = UITableView(frame: self.view.frame, style: .insetGrouped)
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.register(EmployeeTableViewCell.self, forCellReuseIdentifier: "EmployeeTableViewCell")
        return tblView
    }()
    
    private var viewModel = EmployeeListViewModel()
    private var bag = DisposeBag()
    var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard let compnayName = fileName else { return }
        self.title = compnayName
        self.navigationItem.hidesBackButton = true
        let add = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onTapAdd))
        self.navigationItem.rightBarButtonItem = add
        self.view.addSubview(tableView)
        
        bindTableView()
        
        viewModel.fetchEmployees(fileName: compnayName)
    }
    
    @objc func onTapAdd() {
        let tempEmployee = Employee(name: "EMP-\(Int(arc4random_uniform(2000)))", designation: "iOS Developer", resigned: false)
        self.viewModel.addEmployee(employee: tempEmployee, with: self.fileName!)
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Employee>> { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "\(item.designation)"
            return cell
        } titleForHeaderInSection: { dataSorce, sectionIndex in
            return dataSorce[sectionIndex].model
        }

        self.viewModel.employees.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteEmployee(indexPath: indexPath, with: self.fileName!)
        }).disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let alert = UIAlertController(title: "Edit Employee", message: "", preferredStyle: .alert)
            alert.addTextField { texfield in
                texfield.placeholder = "Enter Name"
            }
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                let textField = alert.textFields![0] as UITextField
                guard let newTitle = textField.text else { return }
                self.viewModel.editEmployee(name: newTitle, indexPath: indexPath, with: self.fileName!)
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
}

extension EmployeeListViewController : UITableViewDelegate { }
