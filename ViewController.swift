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
    var alreadyPopulating: Bool = false
    var rowDecrement: Int = 0
    var dragDropIndexPath: IndexPath?
    
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
        createNewItem(indexPath: [0, itemArray.count], rowIncremet: -rowDecrement)              // Create New Item
        
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
        
        alreadyPopulating = false
        
        let indexPath = getIndexPathOfSelectedTextField(textField: textField)
        if let keyBoardSize = keyBoardSize {                                        // UnWrapping KeyBoard Height
            self.tableView.contentInset.bottom = keyBoardSize.height
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)       // Scrolling TextField When Selected
        }
        swapNavigationBtn(with: doneBtn)
    }
    
    // When Current TextField has End Editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !alreadyPopulating {
            populatingCurrentItemWithData(textField: textField)     // Updating Data of Current Item
            removeEmptyTextFields(textField: textField)             // Removing Empty item76
        }
    }
    
    // When Return Key is Pressed on Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {                                    // If Current TextField Text is not Empty
            populatingCurrentItemWithData(textField: textField)         // Updating Data of Current Item
            
            alreadyPopulating = true
            
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
    
    private func doneItem(indexPath: IndexPath) -> NSMutableAttributedString {
        let item = itemArray[indexPath.row].title
        let cutStringAttribute = NSMutableAttributedString.init(string: item!)
        cutStringAttribute.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange.init(location: 0, length: item!.count))
        return cutStringAttribute
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Setting tableView Constraints and Deletegates
    private func settingTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
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

        let item = itemArray[indexPath.row]
        
        cell.cellTextField.text = item.title
        cell.cellTextField.delegate = self
        
        if item.done {
            cell.cellTextField.attributedText = doneItem(indexPath: indexPath)
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        
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

// Completing and Deleting Items using leading and Trailing Gestures
extension ViewController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, Completion) in
            
            if self.itemArray[indexPath.row].done {
                self.rowDecrement -= 1
            }
            
            self.itemArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            Completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func modifyItemPosition(indexPath: IndexPath, completed: Bool) {
        
        let item = self.itemArray[indexPath.row]
        
        item.done = completed
        
        // Deleting Item
        self.itemArray.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        var newIndexPath : IndexPath?
        
        if item.done {
            newIndexPath = [0, self.itemArray.count]
        } else {
            let index = itemArray.count - rowDecrement
            if item.originalIndex!.row <= index {
                newIndexPath = item.originalIndex
            } else {
                newIndexPath = [indexPath.section, self.itemArray.count - rowDecrement]
            }
        }
        // Inserting Item at end of Array
        self.itemArray.insert(item, at: newIndexPath!.row)
        tableView.beginUpdates()
        tableView.insertRows(at: [newIndexPath!], with: .automatic)
        tableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            
            self.itemArray[indexPath.row].originalIndex = indexPath
            
            self.modifyItemPosition(indexPath: indexPath, completed: true)
            
            self.rowDecrement += 1

            completion(true)
        }
        
        let unDoneAction = UIContextualAction(style: .normal, title: "UnDone") { (action, view, completion) in
            
            self.modifyItemPosition(indexPath: indexPath, completed: false)
            self.rowDecrement -= 1
            
            completion(true)
        }
        
        doneAction.backgroundColor = UIColor.systemGreen
        unDoneAction.backgroundColor = UIColor.systemBlue
        
        if itemArray[indexPath.row].done {
            return UISwipeActionsConfiguration(actions: [unDoneAction])
        } else {
            return UISwipeActionsConfiguration(actions: [doneAction])
        }
    }
}

// Sorting Cells
extension ViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = itemArray[sourceIndexPath.row]
        itemArray.remove(at: sourceIndexPath.row)
        itemArray.insert(item, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        dragDropIndexPath = indexPath
        return [UIDragItem(itemProvider: NSItemProvider())]
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        let notCompletedItems = self.itemArray.count - rowDecrement
        
        if session.localDragSession != nil {
            if destinationIndexPath != nil {
                if dragDropIndexPath!.row < notCompletedItems && destinationIndexPath!.row < notCompletedItems{
                    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                }
                else if dragDropIndexPath!.row >= notCompletedItems && destinationIndexPath!.row >= notCompletedItems {
                    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                }
                else {
                    return UITableViewDropProposal(operation: .cancel)
                }
            }
        }
        
        return UITableViewDropProposal(operation: .cancel)
        
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
