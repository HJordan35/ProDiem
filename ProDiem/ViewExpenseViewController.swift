//
//  ViewExpenseViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/26/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import UIKit

class ViewExpenseViewController: UIViewController {
    
    
    @IBOutlet weak var receiptImageView: UIImageView!
    
    var selectedExpense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let expense = selectedExpense {
            if let receipt = expense.receipt {
                let receiptImageData = receipt.imageData
                let receiptImage = UIImage(data: receiptImageData as! Data)
                receiptImageView.image = receiptImage
            }
        
        }
    }
}
