//
//  AddReviewViewController.swift
//  E-Library
//
//  Created by Majlinda - INNO on 18.9.22.
//

import UIKit
import CoreData
import Cosmos

class AddReviewViewController: UIViewController {

    @IBOutlet weak var ratingView: CosmosView!
    var objectID: NSManagedObjectID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func updateReview(objID: NSManagedObjectID){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContex = appDelegate.persistentContainer.viewContext
        do
        {
            let value = try  managedContex.existingObject(with: objID)
            value.setValue(Int(ratingView.rating), forKeyPath: "rating")
            
            do{
                try managedContex.save()
                NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
                self.dismiss(animated: true)
            }
            catch{
                print(error)
            }
        }catch{
            print(error)
        }
    }
    //MARK: - IBActions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        if let objectID = objectID {
            self.updateReview(objID: objectID)
        }
    }
}
