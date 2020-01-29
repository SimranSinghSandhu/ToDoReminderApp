//
//  InfoViewController.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 10/01/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

protocol canChangeInfoDelegate {
    func didEndEditingInfo(titleText: String, titleDescription: String, indexPath: IndexPath, remindAlarm: Bool)
}

class InfoViewController: UIViewController {
    
    var infoDelegate: canChangeInfoDelegate?
    
    let cellId = "cellId"
    
    var itemTitle: String?
    var itemIndexPath: IndexPath?
    var itemDescription: String?
    var itemRemindMeAlarm: Bool?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        settingTableView()
        settingNavigationItems()
        
        setupConstraints()
        
    }
    
    private func settingNavigationItems() {
        
        navigationItem.title = "Details"
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonHandle))
        navigationItem.rightBarButtonItem = doneBtn
        
    }
    
    @objc func doneButtonHandle() {
        tableView.endEditing(true)
        infoDelegate?.didEndEditingInfo(titleText: itemTitle!, titleDescription: itemDescription!, indexPath: itemIndexPath!, remindAlarm: itemRemindMeAlarm!)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
    }
    
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = DetailCustomCell()
            cell.backgroundColor = UIColor.white
            cell.itemTitle.text = itemTitle
            cell.itemTitle.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = DescriptionCell()
            cell.backgroundColor = UIColor.white
            cell.itemDescription.text = itemDescription
            cell.itemDescription.delegate = self
            return cell
        } else {
            let cell = SwitchAlarmCell()
            cell.switchDelegate = self
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
            cell.switchBtn.isOn = itemRemindMeAlarm!
            cell.textLabel?.text = "Remind me"
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}

extension InfoViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        itemTitle = textField.text
    }
}

extension InfoViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        itemDescription = textView.text
    }
}

extension InfoViewController: switchBtnDelegate {
    func didSwitchValueChanged(isOn: Bool) {
        itemRemindMeAlarm = isOn
    }
}

