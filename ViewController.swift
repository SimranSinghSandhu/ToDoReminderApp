//
//  ViewController.swift
//  ToDoReminderApp
//
//  Created by Simran Singh Sandhu on 14/12/19.
//  Copyright © 2019 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellId = "cellId"
    var itemArray = [Item]()
    var currentIndexPath: IndexPath?
    
    var addBtn: UIBarButtonItem = {
        let barBtn = UIBarButtonItem()
        return barBtn
    }()
    var doneBtn: UIBarButtonItem = {
        let barBtn = UIBarButtonItem()
        return barBtn
    }()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.backgroundColor = UIColor.white
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        settingTableView()
        settingNavigationItems()
    }
}

// Setting Up Navigation Items
extension ViewController {
    private func settingNavigationItems() {
        addBtn.title = "Add"
        addBtn.action = #selector(addBtnHandle)
        addBtn.target = self
        addBtn.style = .done
        
        doneBtn.title = "Done"
        doneBtn.action = #selector(doneBtnHandle)
        doneBtn.target = self
        doneBtn.style = .done
        
        navigationItem.rightBarButtonItem = addBtn
    }
    
    @objc func doneBtnHandle() {
        tableView.endEditing(true)
        swapNavigationBtn(with: addBtn)
    }
    
    @objc func addBtnHandle() {
        swapNavigationBtn(with: doneBtn)
        createNewItem(indexPath: [0, itemArray.count])
    }
    
    private func swapNavigationBtn(with barBtn: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = barBtn
    }
    
    private func createNewItem(indexPath: IndexPath) {
        
        currentIndexPath = indexPath
        
        let newItem = Item()
        itemArray.insert(newItem, at: indexPath.row)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
}

// Setting up TextField Delegate Methods.
extension ViewController: UITextFieldDelegate {
    
    private func getIndexPathOfSelectedTextField(textField: UITextField, rowIncrement: Int) -> IndexPath {
        let textFieldPoint = textField.convert(textField.bounds.origin, to: tableView)
        var indexPath = tableView.indexPathForRow(at: textFieldPoint)
        indexPath!.row += rowIncrement
        return indexPath!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        swapNavigationBtn(with: doneBtn)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            createNewItem(indexPath: getIndexPathOfSelectedTextField(textField: textField, rowIncrement: 1))
        } else {
            tableView.endEditing(true)
            swapNavigationBtn(with: addBtn)
        }
        return true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func settingTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        cell.cellTextField.text = itemArray[indexPath.row].title
        cell.cellTextField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CustomCell {
            if currentIndexPath?.row == indexPath.row {
                cell.cellTextField.becomeFirstResponder()
            }
        }
    }
}
