//
//  CustomCell.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 17/12/19.
//  Copyright © 2019 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    let infoButton: UIButton = {
        let spacing: CGFloat = 12
        
        let btn = UIButton()
//        btn.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        btn.setImage(UIImage(named: "info_Btn.png"), for: .normal)
        
//        btn.backgroundColor = UIColor.gray
        btn.imageView?.contentMode = .scaleToFill
        
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return btn
    }()
    
    let doneView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
        return view
    }()
    
    let cellTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter New Item..."
        textField.textColor = UIColor.black
        textField.rightViewMode = .whileEditing
//        textField.leftViewMode = .
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(cellTextField)
        cellTextField.rightView = infoButton
        
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func settingConstraints() {
        
        cellTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        cellTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        cellTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        cellTextField.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
}
