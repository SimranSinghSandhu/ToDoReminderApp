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
    var isAdding = false
    
    var keyBoardSize: CGRect?
    
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
        settingKeyBoard()
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
        endEditing()                    // When Done Button is Pressed End Editing.
    }
    
    @objc func addBtnHandle() {
        swapNavigationBtn(with: doneBtn)
        createNewItem(indexPath: [0, itemArray.count], rowIncremet: 0)              // Create New Item
        tableView.scrollToRow(at: [0, currentIndexPath!.row], at: .top, animated: true)     // Scroll TableView to Created Item (Cell)
    }
    
    private func swapNavigationBtn(with barBtn: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = barBtn
    }
    
    private func createNewItem(indexPath: IndexPath, rowIncremet: Int) {
        
        isAdding = true
        
        let newIndexPath: IndexPath = [indexPath.section, indexPath.row + rowIncremet]
        
        currentIndexPath = newIndexPath         // Current IndexPath to make it Become First Responder in willDisplayTableView Method
        let newItem = Item()
        newItem.title = ""
        itemArray.insert(newItem, at: newIndexPath.row)                     // Insert Item in Array
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath], with: .automatic)          // Insert Item in TableView
        tableView.endUpdates()
        
    }
    
    private func endEditing() {                     // When Return key or Done Button is Pressed.
        tableView.endEditing(true)
        swapNavigationBtn(with: addBtn)
        isAdding = false
    }
}

// Setting up TextField Delegate Methods.
extension ViewController: UITextFieldDelegate {
    
    // Get the Current IndexPath of the TextField Selected.
    private func getIndexPathOfSelectedTextField(textField: UITextField) -> IndexPath {
        let textFieldPoint = textField.convert(textField.bounds.origin, to: tableView)
        let indexPath = tableView.indexPathForRow(at: textFieldPoint)
        return indexPath!
    }
    
    // When TextField is Selected
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        if let keyBoardSize = keyBoardSize {                                        // UnWrapping KeyBoard Height
            self.tableView.contentInset.bottom = keyBoardSize.height
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)       // Scrolling TextField When Selected
        }
        
        swapNavigationBtn(with: doneBtn)
    }
    
    // When Current TextField has End Editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        populatingCurrentItemWithData(textField: textField)     // Updating Data of Current Item
        removeEmptyTextFields(textField: textField)             // Removing Empty item
    }
    
    // When Return Key is Pressed on Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {                                    // If Current TextField Text is not Empty
            populatingCurrentItemWithData(textField: textField)         // Updating Data of Current Item
            
            let indexPath = getIndexPathOfSelectedTextField(textField: textField)
            createNewItem(indexPath: indexPath, rowIncremet: 1)         // Create New Item

            self.tableView.contentInset.bottom = keyBoardSize!.height           // Modify TableView ContentInset according to Keyboard Height
            tableView.scrollToRow(at: currentIndexPath!, at: .middle, animated: true)     // Scroll to Current Cell


        } else {
            endEditing()       // End Editing when Return Key is Pressed and TextField Text is Empty
        }
        
        return true
    }
    
    // Updating Current Item Data in Array
    private func populatingCurrentItemWithData(textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        itemArray[indexPath.row].title = textField.text
    }
    
    // Remove Empty Items from Array
    private func removeEmptyTextFields(textField: UITextField) {
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        if itemArray[indexPath.row].title == "" {
            itemArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    // Setting tableView Constraints and Deletegates
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
            if currentIndexPath?.row == indexPath.row && isAdding {
                cell.cellTextField.becomeFirstResponder()
            }
        }
    }
}

extension ViewController {
    // Setting Up Keyboard Function
    private func settingKeyBoard() {
    
        // When Keyboard is Shown
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        // When Keyboard is Hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyBoardSize = keyboardFrame            // Get the Height of Keyboard

        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset = .zero              // Reset TableView Content Inset when Keyboard will Hide.
    }
}
