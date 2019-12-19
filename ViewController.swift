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
    var isAdding: Bool = false
    
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
        createNewItem(indexPath: [0, itemArray.count], rowIncremet: 0)
    }
    
    private func swapNavigationBtn(with barBtn: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = barBtn
    }
    
    private func createNewItem(indexPath: IndexPath, rowIncremet: Int) {
        
        let newIndexPath: IndexPath = [indexPath.section, indexPath.row + rowIncremet]
        
        currentIndexPath = newIndexPath
        
        let newItem = Item()
        newItem.title = ""
        itemArray.insert(newItem, at: newIndexPath.row)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.endUpdates()
    }
}

// Setting up TextField Delegate Methods.
extension ViewController: UITextFieldDelegate {
    
    private func getIndexPathOfSelectedTextField(textField: UITextField) -> IndexPath {
        let textFieldPoint = textField.convert(textField.bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: textFieldPoint)
        return indexPath!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        swapNavigationBtn(with: doneBtn)
    }
    
    // When Current TextField has End Editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        populatingCurrentItemWithData(textField: textField)     // Updating Data of Current Item
        removeEmptyTextFields()                                 // Removing Empty Items from TableView and Array
        if isAdding {                                           // Checking if Return Key is Pressed
            // if Yes, Add a New Item
            let indexPath = getIndexPathOfSelectedTextField(textField: textField)
            createNewItem(indexPath: indexPath, rowIncremet: 1)
            isAdding = false
        }
    }
    
    // When Return Key is Pressed on Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {                         // If Current TextField Text is not Empty
            isAdding = true
            textFieldDidEndEditing(textField)               // Calling TextFieldDidEndEditing Function
        } else {
            tableView.endEditing(true)
            swapNavigationBtn(with: addBtn)
        }
        
        return true
    }
    
    // Updating Current Item Data in Array
    private func populatingCurrentItemWithData(textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        itemArray[indexPath.row].title = textField.text
    }
    
    // Remove Empty Items from Array
    private func removeEmptyTextFields() {
        var indexDecreaser = 0
        for index in 0..<itemArray.count {
            let currentIndex = index - indexDecreaser
            if itemArray[currentIndex].title == "" {
                itemArray.remove(at: currentIndex)
                tableView.deleteRows(at: [[0, currentIndex]], with: .automatic)
                indexDecreaser += 1
                print("Deleteing Items")
            }
        }
        indexDecreaser = 0
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
