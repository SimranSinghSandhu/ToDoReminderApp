//
//  infoViewCustomCell.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 10/01/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class DetailCustomCell: UITableViewCell {
    
    let itemTitle: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(itemTitle)
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func settingConstraints() {
        itemTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        itemTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        itemTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        itemTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
