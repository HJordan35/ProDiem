//
//  ViewExpenseViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/26/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import UIKit

class ViewExpenseViewController: UIViewController {
    
    
    @IBOutlet weak var modalUIView: UIView!
    @IBOutlet weak var receiptImageView: UIImageView!
    
    var selectedExpense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round the edges of the view
        modalUIView.layer.borderColor = UIColor.appDarkGreen().cgColor
        modalUIView.layer.borderWidth = 2
        modalUIView.layer.cornerRadius = 10
        
        modalUIView.layer.shadowColor = UIColor.black.cgColor
        modalUIView.layer.shadowOpacity = 1
        modalUIView.layer.shadowOffset = CGSize.zero
        modalUIView.layer.shadowRadius = 10
        modalUIView.layer.shadowPath = UIBezierPath(rect: modalUIView.bounds).cgPath
        
        if let expense = selectedExpense {
            if let receipt = expense.receipt {
                let receiptImageData = receipt.imageData
                let receiptImage = UIImage(data: receiptImageData as! Data)
                receiptImageView.image = receiptImage
            }
        
        }
    }
}
