//
//  ViewTripViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 4/28/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import UIKit
import KAProgressLabel

class ViewTripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var tripExpenseCollectionView: UICollectionView!
    @IBOutlet weak var tripHeaderUIView: UIView!
    @IBOutlet weak var dailySpendLabel: UILabel!
    @IBOutlet weak var dailyTargetLabel: UILabel!
    @IBOutlet weak var totalExpensesLabel: UILabel!
    @IBOutlet weak var dayRemainingLabel: UILabel!
    @IBOutlet weak var tripExpensesTableView: UITableView!
    @IBOutlet weak var tripRemainingLabel: UILabel!
    @IBOutlet weak var tripRemainingProgress: KAProgressLabel!
    @IBOutlet weak var dayRemainingProgress: KAProgressLabel!
    @IBOutlet weak var tripExpensesView: UIView!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDateRangeLabel: UILabel!
    
    //Expense Variables
    var currentTrip: Trip!
    var totalTripSpend: Double = 0.0
    var previousDayExpenses: Double = 0.0
    var currentDayExpenses: Double = 0.0
    
    var dailyTargetSpend: Double = 0.0
    
    //Formatters
    let currencyFormatter = NumberFormatter()
    let dateFormatter = DateFormatter()
    
    //Data Retreival
    var expenseManager = ExpenseManager.sharedManager
    var tripExpenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewNib = UINib(nibName: "ExpenseCollectionViewCell", bundle: nil)
        tripExpenseCollectionView.register(viewNib, forCellWithReuseIdentifier: "ExpenseCollectionViewCell")
        tripExpenseCollectionView.delegate = self
        tripExpenseCollectionView.dataSource = self
        
        //Set Up Currency and Date formatters
        currencyFormatter.numberStyle = .currency
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        
        
        //Set edges of the header view
        tripHeaderUIView.layer.borderWidth = 0.5
        tripHeaderUIView.layer.borderColor = UIColor.appDarkGreen().cgColor
        //Round Edges of Expenses View + add shadow
        tripExpensesView.layer.cornerRadius = 10;
        
        tripExpensesView.layer.shadowColor = UIColor.black.cgColor
        tripExpensesView.layer.shadowOpacity = 1
        tripExpensesView.layer.shadowOffset = CGSize.zero
        tripExpensesView.layer.shadowRadius = 10
        tripExpensesView.layer.shadowPath = UIBezierPath(rect: tripExpensesView.bounds).cgPath

        
        self.tripRemainingProgress.trackWidth = 18;         // Defaults to 5.0
        self.tripRemainingProgress.progressWidth = 18;        // Defaults to 5.0
        self.tripRemainingProgress.roundedCornersWidth = 18; // Defaults to 0
        self.tripRemainingProgress.trackColor = UIColor.appOrangeColorFade()
        self.tripRemainingProgress.progressColor = UIColor.appOrangeColor()
        self.tripRemainingProgress.endDegree = 0
        self.tripRemainingProgress.startDegree = 0
        
        self.dayRemainingProgress.trackWidth = 18;         // Defaults to 5.0
        self.dayRemainingProgress.progressWidth = 18;        // Defaults to 5.0
        self.dayRemainingProgress.roundedCornersWidth = 18; // Defaults to 0
        self.dayRemainingProgress.trackColor = UIColor.appLimeGreenColorFade()
        self.dayRemainingProgress.progressColor = UIColor.appLimeGreenColor()
        self.dayRemainingProgress.endDegree = 0
        self.dayRemainingProgress.startDegree = 0
        
        
        if let trip = currentTrip {
            let remainingBalanceValue = Double(trip.tripTotalPerDiem!) - Double(trip.tripUsedPerDiem!)
            let tripStartDateString = dateFormatter.string(from: trip.startDate as! Date)
            let tripEndDateString = dateFormatter.string(from:trip.endDate as! Date)
            let concatDate = tripStartDateString + " - " + tripEndDateString
            
            tripRemainingLabel.text = String("$ ") + String(format: "%0.2f", remainingBalanceValue)
            tripNameLabel.text = trip.name
            tripDateRangeLabel.text = concatDate
            
            
            tripExpenses.removeAll()
            tripExpenses = expenseManager.fetchAllTripExpenses(trip)
            refreshExpenseTotal()
            calculateTargetDailySpend()
            
            updateDayRemainingDollars()
            updateTripRemainingDollars()
            
        }
    }
    
    @IBAction func unwindCancel(_ sending: UIStoryboardSegue) {
        //Cancel
    }
    
    @IBAction func unwindAddExpense(_ sending: UIStoryboardSegue) {
        if let sourceViewController = sending.source as? AddExpenseViewController, let newExpense = sourceViewController.newExpense {
            
            let newIndexPath = IndexPath(row: tripExpenses.count, section: 0)
            tripExpenses.append(newExpense)
            
            tripExpenseCollectionView.insertItems(at: [newIndexPath])
        
            //Expense Progress
            refreshExpenseTotal()
            calculateTargetDailySpend()
            
            updateTripRemainingDollars()
            updateDayRemainingDollars()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tripExpenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tripExpenseCollectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseCollectionViewCell", for: indexPath) as! ExpenseCollectionViewCell
        
        //Format the Collection View Cell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10        
        
        //Set Cell Values
        let currentExpense = tripExpenses[indexPath.row] as Expense
        
        if let amount = currentExpense.amount{
            cell.expenseAmountLabel.text = currencyFormatter.string(from: amount)
        }
        if let date = currentExpense.date {
            cell.expenseDateLabel.text = dateFormatter.string(from:date as Date)
        }
        cell.expenseNameLabel.text = currentExpense.name

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedExpense: Expense = tripExpenses[indexPath.row]
         self.performSegue(withIdentifier: "ShowSelectedExpense", sender: selectedExpense)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExpenseSegue" {
            let addExpenseVC = segue.destination as! AddExpenseViewController
            addExpenseVC.currentTrip =  self.currentTrip
        }
        
        if segue.identifier == "ShowSelectedExpense" {
            let viewExpenseVC = segue.destination as! ViewExpenseViewController
            viewExpenseVC.selectedExpense =  sender as? Expense
        }
    }
    
    //Function which updates the Total Expenses currently accrued on the trip
    func refreshExpenseTotal() {
        let currentDate = Date()
        let date1 = (Calendar.current as NSCalendar).component([NSCalendar.Unit.day], from: currentDate)
        
        totalTripSpend = 0.0
        previousDayExpenses = 0.0
        currentDayExpenses = 0.0
        
        
        if tripExpenses.count > 0 {
            for expense in tripExpenses {
                let date2 = (Calendar.current as NSCalendar).component([NSCalendar.Unit.day], from: expense.date! as Date)
                if let expenseAmount = expense.amount {
                    //get current day and previous day expense values
                    if date2 < date1 {
                        previousDayExpenses += Double(expenseAmount)
                    }
                    else if date2 == date1 {
                        currentDayExpenses += Double(expenseAmount)
                    }
                    
                    //accumulate the total expenses
                    totalTripSpend = totalTripSpend + Double(expenseAmount)
                }
            }
        }
        
        currentTrip?.tripUsedPerDiem = totalTripSpend as NSNumber?
        dailySpendLabel.text = String("$ ") + String(format: "%0.2f", currentDayExpenses)
        totalExpensesLabel.text = String("$ ") + String(format: "%0.2f", totalTripSpend)
    }
    
    //Overview
    //** Calculate the amount available per day considering the amount of expenses used in previous days and days remaining in the trip
    func calculateTargetDailySpend() {
        
        let currentDate = Date()
    
        //get the days remaining in the trip
        var date1 = (Calendar.current as NSCalendar).component([NSCalendar.Unit.day], from: currentDate)
        let date2 = (Calendar.current as NSCalendar).component([NSCalendar.Unit.day], from: currentTrip.endDate! as Date)
        
        //if the final date of the trip has passed, then only the final calulations based on the final day should be shown
        if date1 > date2 {
            date1 = date2
        }
        
        let remainingDaysInTrip = date2 - date1 + 1 //1 is added to ensure the final day of the trip is considerd
        
        //subtract value from previous days from the trips total available expenses and divide by days remaining to get the dailyTarget
        let rawRemainingValue = Double(currentTrip.tripTotalPerDiem!) - previousDayExpenses
        
        dailyTargetSpend = rawRemainingValue/Double(remainingDaysInTrip)
        dailyTargetLabel.text = String("$ ") + String(format: "%0.2f", dailyTargetSpend)
        
    }
    
    func updateDayRemainingDollars() {
        
        var percentOfTotalProgress = 1.0
        let remainingBalance = dailyTargetSpend - currentDayExpenses
        
        //Based on the remaining dollars, update the progress of the label
        let percentOfTotalExpenses = currentDayExpenses/dailyTargetSpend
        
        if percentOfTotalExpenses < 1 {
            percentOfTotalProgress = percentOfTotalExpenses * 360
        } else {
            percentOfTotalProgress = 1.0
        }
        
        self.dayRemainingProgress.setEndDegree(CGFloat(percentOfTotalProgress), timing:TPPropertyAnimationTimingEaseInEaseOut, duration: 1, delay: 0)
        self.dayRemainingLabel.text = String("$ ") + String(format: "%0.2f", remainingBalance)
        
    }
    
    func updateTripRemainingDollars() {
        
        let usedPerDiem = Double(currentTrip.tripUsedPerDiem ?? 0)
        let totalPerDiem = Double(currentTrip.tripTotalPerDiem ?? 0)
        var percentOfTotalProgress = 1.0
        let remainingBalance = totalPerDiem - usedPerDiem
        
        //Based on the remaining dollars, update the progress of the label
        let percentOfTotalExpenses = usedPerDiem/totalPerDiem
        
        if percentOfTotalExpenses < 1 {
           percentOfTotalProgress = percentOfTotalExpenses * 360
        } else {
            percentOfTotalProgress = 1.0
        }
        
       // self.tripRemainingProgress.endDegree = CGFloat(percentOfTotalProgress)
        self.tripRemainingProgress.setEndDegree(CGFloat(percentOfTotalProgress), timing:TPPropertyAnimationTimingEaseInEaseOut, duration: 1, delay: 0)
        self.tripRemainingLabel.text = String("$ ") + String(format: "%0.2f", remainingBalance)
    }
    
}
