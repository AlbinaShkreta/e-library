//
//  ProfileViewController.swift
//  E-Library
//
//  Created by Majlinda - INNO on 17.9.22.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var phoneTextField: TextField!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageContainerView.showShadow()
        retrieveData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    func retrieveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do{
            let results = try managedContex.fetch(request)
            for data in results as! [NSManagedObject]{
                self.firstNameTextField.text = "\(data.value(forKey: "firstName") ?? "")"
                self.lastNameTextField.text = "\(data.value(forKey: "lastName") ?? "")"
                self.emailTextField.text = "\(data.value(forKey: "email") ?? "")"
                self.phoneTextField.text = "\(data.value(forKey: "phoneNumber") ?? "")"
            }
        }
        catch{
            print("failed")
        }
    }
    //MARK: - IBActions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let story = UIStoryboard(name: "Login", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
