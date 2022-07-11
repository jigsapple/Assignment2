//
//  EmployeeTableViewCell.swift
//  Assignment2
//
//  Created by Jignesh on 15/06/22.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "EmployeeTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
