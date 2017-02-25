//
//  AddExpenseViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 6/9/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddExpenseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var expenseDateLabel: UITextField!
    @IBOutlet weak var expenseAmountLabel: UITextField!
    @IBOutlet weak var expenseNameLabel: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var captureButton: UIView!
    @IBOutlet weak var modalUIView: UIView!
    
    var currentTrip: Trip?
    var expenseDate: Date?
    var receiptImage: UIImage?
    
    var newExpenseName: String?
    var newExpenseAmount: Double?
    var newExpenseDate: Date?
    var newExpense: Expense?
    var newReceipt: UIImage?
    var newReceiptThumb: UIImage?
    
    let expenseManager = ExpenseManager.sharedManager
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        //Round the edges of the view
        modalUIView.layer.borderColor = UIColor.appDarkGreen().cgColor
        modalUIView.layer.borderWidth = 2
        modalUIView.layer.cornerRadius = 10
        
        modalUIView.layer.shadowColor = UIColor.black.cgColor
        modalUIView.layer.shadowOpacity = 1
        modalUIView.layer.shadowOffset = CGSize.zero
        modalUIView.layer.shadowRadius = 10
        modalUIView.layer.shadowPath = UIBezierPath(rect: modalUIView.bounds).cgPath
        
        //Round edges of the buttons
        addButton.layer.borderColor = UIColor.appDarkGreen().cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.cornerRadius = 10
        
        cancelButton.layer.borderColor = UIColor.appDarkGreen().cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 10

        captureButton.layer.borderColor = UIColor.appDarkGreen().cgColor
        captureButton.layer.borderWidth = 1
        captureButton.layer.cornerRadius = 10
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as! UIButton === addButton {
            if let name = expenseNameLabel.text {
                newExpenseName = name
                if let amount = expenseAmountLabel.text {
                    newExpenseAmount = Double(amount)
                    if let date = expenseDate {
                        newExpenseDate = date
                        if let receipt = receiptImage {
                            newReceipt = receipt
                            newExpense = expenseManager.createNewExpense(newExpenseName!, amount: newExpenseAmount!, date: newExpenseDate!, trip: currentTrip!, receipt: newReceipt!)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        receiptImage = info[UIImagePickerControllerOriginalImage] as! UIImage?
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDate(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        expenseDate = Date()
        expenseDateLabel.text = dateFormatter.string(from: expenseDate!)
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
    }
    
    func handleDatePicker(_ sender: UIDatePicker){
        
        expenseDate = sender.date
        expenseDateLabel.text = dateFormatter.string(from: sender.date)
    }
}
