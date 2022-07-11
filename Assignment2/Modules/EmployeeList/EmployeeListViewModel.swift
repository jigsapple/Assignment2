//
//  EmployeeListViewModel.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class EmployeeListViewModel {
    
    var employees = BehaviorSubject(value: [SectionModel(model: "", items: [Employee]())])
    var empList: [Employee] = []
    
    func fetchEmployees(fileName: String) {
        guard let data = JSONDataManager.load(fileName, with: [Employee].self) else { return }
        empList = data
        let section = SectionModel(model: "Employee List", items: empList)
        self.employees.on(.next([section]))
    }
    
    func addEmployee(employee: Employee, with fileName: String) {
        guard var sections = try? employees.value() else { return }
        var currentSection = sections[0]
        currentSection.items.append(employee)
        sections[0] = currentSection
        self.employees.onNext(sections)
        empList.append(employee)
        JSONDataManager.save(empList, with: fileName)
    }
     
    func editEmployee(name:String, indexPath:IndexPath, with fileName: String) {
        guard var sections = try? employees.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].name = name
        sections[indexPath.section] = currentSection
        self.employees.onNext(sections)
        empList[indexPath.row].name = name
        JSONDataManager.save(empList, with: fileName)
    }
    
    func employeeResigned(indexPath: IndexPath, with fileName: String) {
        guard var sections = try? employees.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].resigned = true
        sections[indexPath.section] = currentSection
        self.employees.onNext(sections)
        empList[indexPath.row].resigned = true
        JSONDataManager.save(empList, with: fileName)
    }
    
    func deleteEmployee(indexPath: IndexPath, with fileName: String) {
        guard var sections = try? employees.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.employees.onNext(sections)
        empList.remove(at: indexPath.row)
        JSONDataManager.save(empList, with: fileName)
    }
}
