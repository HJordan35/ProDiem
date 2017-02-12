//
//  ExpenseCollectionViewCell.swift
//  ProDiem
//
//  Created by Henry Jordan III on 2/4/17.
//  Copyright © 2017 Henry ACN. All rights reserved.
//

import Foundation
import UIKit

class ExpenseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var expenseCollectionViewCellContainer: UIView!
    
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expenseNameLabel: UILabel!
    @IBOutlet weak var expenseDateLabel: UILabel!
    @IBOutlet weak var expenseCardLabel: UILabel!
    @IBOutlet weak var expenseTypeLabel: UILabel!
}
