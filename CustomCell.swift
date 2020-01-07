//
//  CustomCell.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 17/12/19.
//  Copyright © 2019 Simran Singh Sandhu. All rights reserved.
//

import UIKit

protocol infoButtonDelegate {
    func didPressInfoButton(textField: UITextField)
}

class CustomCell: UITableViewCell {
    
    var btnDelegate: infoButtonDelegate?
    
    let infoButton: UIButton = {
        let spacing: CGFloat = 12
        
        let btn = UIButton()
        btn.setImage(UIImage(named: "info_Btn.png"), for: .normal)

        btn.imageView?.contentMode = .scaleToFill
        
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.imageEdgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return btn
    }()
    
    let cellTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter New Item..."
        textField.textColor = UIColor.black
        textField.adjustsFontSizeToFitWidth = true
        textField.rightViewMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(cellTextField)
        
        infoButton.addTarget(self, action: #selector(infoButtonHandle), for: .touchUpInside)
        
        cellTextField.rightView = infoButton
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func settingConstraints() {
        
        cellTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        cellTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        cellTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cellTextField.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
    }
    
    @objc func infoButtonHandle() {
        btnDelegate?.didPressInfoButton(textField: cellTextField)
    }
}
