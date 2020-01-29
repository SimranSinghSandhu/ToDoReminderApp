//
//  infoViewCustomCell.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 10/01/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

protocol switchBtnDelegate {
    func didSwitchValueChanged(isOn: Bool)
}

class DetailCustomCell: UITableViewCell {
    
    let itemTitle: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.white
        textField.text = "Enter Title"
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

class DescriptionCell: UITableViewCell {
    
    let itemDescription: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.white
        textView.text = "Enter Description."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(itemDescription)
        settingConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func settingConstraints() {
        itemDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        itemDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        itemDescription.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        itemDescription.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true        
    }
}

class SwitchAlarmCell: UITableViewCell {

    var switchDelegate: switchBtnDelegate?
    
    let switchBtn: UISwitch = {
        let btn = UISwitch()
        btn.isOn = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(switchBtn)
        switchBtn.addTarget(self, action: #selector(switchBtnHandle), for: .valueChanged)
        settingConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func switchBtnHandle(value: UISwitch) {
        switchDelegate?.didSwitchValueChanged(isOn: value.isOn)
    }

    private func settingConstraints() {
        switchBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        switchBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switchBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        switchBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
}

