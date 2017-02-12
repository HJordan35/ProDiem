//
//  ViewController.swift
//  ProDiem
//
//  Created by Henry Jordan III on 4/28/16.
//  Copyright © 2016 Henry ACN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tripsCollectionView: UICollectionView!
    
    @IBOutlet weak var businessTripsView: UIView!
    let tripManager = TripManager.sharedManager 
    
    @IBOutlet weak var businessTripCountLabel: UILabel!
    @IBOutlet weak var peronalTripCountLabel: UILabel!
    @IBOutlet weak var personalTripsCounterView: UIView!
    @IBOutlet weak var businessTripCounterView: UIView!
    @IBOutlet weak var personalTripsView: UIView!
    var addTripViewController: AddTripViewController!
    var viewTripViewController: ViewTripViewController!
    var mainNavigationController: UINavigationController!
    
    let dateFormatter = DateFormatter()
    
    var newTrip: Trip?
    var trips: [Trip] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = UIColor.appDarkGreen()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white];

        let nib = UINib(nibName: "TripsCollectionViewCell", bundle: nil)
        tripsCollectionView.register(nib, forCellWithReuseIdentifier: "TripsCollectionViewCell")
        tripsCollectionView.delegate = self
        tripsCollectionView.dataSource = self
        
        //Format buttons
        businessTripsView.layer.borderColor = UIColor.lightGray.cgColor
        businessTripsView.layer.borderWidth = 0.5
        businessTripsView.layer.cornerRadius = 8
        
        businessTripCounterView.layer.borderColor = UIColor.lightGray.cgColor
        businessTripCounterView.layer.borderWidth = 0.5
        businessTripCounterView.layer.cornerRadius = 10
        
        personalTripsView.layer.borderColor = UIColor.lightGray.cgColor
        personalTripsView.layer.borderWidth = 0.5
        personalTripsView.layer.cornerRadius = 8
        
        personalTripsCounterView.layer.borderColor = UIColor.lightGray.cgColor
        personalTripsCounterView.layer.borderWidth = 0.5
        personalTripsCounterView.layer.cornerRadius = 10
        
        //Set Formatters
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        //establish long press gesture
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongPress(_:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.tripsCollectionView.addGestureRecognizer(lpgr)
        
        trips .removeAll()
        trips = tripManager.fetchAllTrips()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentTrip = trips[indexPath.row]
        
        let cell = tripsCollectionView.dequeueReusableCell(withReuseIdentifier: "TripsCollectionViewCell", for: indexPath) as! TripsCollectionViewCell
        
        //Format the Collection View Cell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        
        let totalPerDiem = currentTrip.tripTotalPerDiem!
        let dailyPerDiem = currentTrip.dailyPerDiem!
        cell.tripLabel.text = currentTrip.name
        cell.startDateLabel.text = dateFormatter.string(from: currentTrip.startDate! as Date)
        cell.endDateLabel.text = dateFormatter.string(from: currentTrip.endDate! as Date)
        cell.totalPerDiemLabel.text = String("$ \(totalPerDiem)")
        cell.perDiemLabel.text = String("$ \(dailyPerDiem) per day")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTrip: Trip = trips[indexPath.row]
        self.performSegue(withIdentifier: "ShowViewTrip", sender: selectedTrip)
    }

    //MARK: IBActions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func unwindToAllTripsView(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddTripViewController, let newTrip = sourceViewController.trip {
            
            let newIndexPath = IndexPath(row: trips.count, section: 0)
            trips.append(newTrip)
            tripsCollectionView.insertItems(at: [newIndexPath])
        }
    }
    
    @IBAction func unwindCancel(_ sending: UIStoryboardSegue) {
        //Cancel 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowViewTrip" {
            let viewTripVC = segue.destination as! ViewTripViewController
            viewTripVC.currentTrip = sender as? Trip
        }
    }
    
    func handleLongPress(_ longPress: UIGestureRecognizer) {
    
        
        let p = longPress.location(in: self.tripsCollectionView)
        let indexPath = self.tripsCollectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in self.handleDelete(index) }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            } else {
            print("Could not find index path")
        }
    }
    
    func handleDelete(_ indexPath: IndexPath) {
        let tripForDelete: Trip = trips[indexPath.row]
        tripManager.deleteTrip(tripForDelete)
        
        trips.remove(at: indexPath.row)
        tripsCollectionView.deleteItems(at: [indexPath])
    }

}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func addTripViewController() -> AddTripViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "AddTripViewController") as? AddTripViewController
    }
}


