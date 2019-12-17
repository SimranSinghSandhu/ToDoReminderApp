//
//  CustomCell.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 17/12/19.
//  Copyright © 2019 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let cellTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter New Item..."
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func settingTextField() {
        
        self.addSubview(cellTextField)
        
        cellTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        cellTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        cellTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        cellTextField.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
}
