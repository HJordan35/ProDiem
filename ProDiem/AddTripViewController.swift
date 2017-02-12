//
//  AddTripViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 4/28/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var dayPerDiemTextField: UITextField!
    @IBOutlet weak var tripTotalPerDiemTextFIeld: UILabel!
    @IBOutlet weak var tripEndDate: UITextField!
    @IBOutlet weak var tripStartDate: UITextField!

    @IBOutlet weak var saveButton: UIButton!
   
    var trip: Trip?
    var startDate: Date?
    var endDate: Date?
    var totalPerDiem: Double?
    var dayPerDiem = 0.0
    let tripManager = TripManager.sharedManager
    
    let dateFormatter = DateFormatter()
    let currencyFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set up formatters
        currencyFormatter.numberStyle = .currency
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backTapped))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tripName: String?
        
        if sender as! UIButton === saveButton {
            tripName = tripNameTextField.text ?? ""

            if (tripName == "" || startDate == nil || endDate == nil) {
                let validationAlert = UIAlertView(title: "Attention!", message: "Please Populate All Fields Before Saving", delegate: self, cancelButtonTitle: "OK")
                validationAlert.show()
            } else {
                trip = tripManager.createNewTrip(tripName, dailyPerDiem: dayPerDiem, totalPerDiem: totalPerDiem, tripStart: startDate, tripEnd: endDate)
            }
        }
    }
    
    @IBAction func backTapped() {
        view.endEditing(true)
    }
    
    @IBAction func cancelButtonPressed() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addDate(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        if(sender == tripStartDate){
            datePickerView.tag = 1
            startDate = Date()
            tripStartDate.text = dateFormatter.string(from: startDate!)
        }
        else {
            datePickerView.tag = 2
            endDate = Date()
            tripEndDate.text = dateFormatter.string(from: endDate!)
        }
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func calculateTotalPerDiem() {
        let input = Double(dayPerDiemTextField.text!)
        dayPerDiem = input ?? 0.0
        
        if let startDateInput = startDate {
            if let endDateInput = endDate {
                    let options = NSCalendar.Options()
                    let real = (Calendar.current as NSCalendar).components([NSCalendar.Unit.day], from: startDateInput, to: endDateInput, options: options)
                
                if var duration = real.day {
                    duration += 1
                    totalPerDiem = Double(duration) * dayPerDiem
                }
                    tripTotalPerDiemTextFIeld.text = currencyFormatter.string(from: totalPerDiem! as NSNumber)
            }
        }
    }
    
    func handleDatePicker(_ sender: UIDatePicker){
        if sender.tag == 1 {
            startDate = sender.date
            tripStartDate.text = dateFormatter.string(from: sender.date)
        }
        else {
            endDate = sender.date
            tripEndDate.text = dateFormatter.string(from: sender.date)
        }
        
        self.calculateTotalPerDiem()
    }
    
    
}
