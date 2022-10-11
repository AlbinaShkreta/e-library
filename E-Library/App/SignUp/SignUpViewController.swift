//
//  SignUpViewController.swift
//  OrderApp
//
//  Created by Albina Shkreta on 17.9.22.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var phoneNumberTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    //IBActions
    @IBAction func singUpButtonPressed(_ sender: Any) {
        addUser()
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Function
    
    func navigateToHomeScreen(){
        let tabBarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTab") as! UITabBarController
        view.window?.rootViewController = tabBarViewController
        view.window?.makeKeyAndVisible()
    }

    func addUser(){
        //Validate fields
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            self.firstNameTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty first name." )
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            self.firstNameTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty last name." )
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            self.emailTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty email." )
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            self.passwordTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty password.")
            return
        }
        guard let phone = phoneNumberTextField.text, !phone.isEmpty else {
            self.phoneNumberTextField.becomeFirstResponder()
            self.showAlertWith(title: "Alert", message: "Empty password.")
            return
        }
        
        
        //add data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContex)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContex)
        user.setValue(firstName, forKey: "firstName")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(email, forKey: "email")
        user.setValue(password, forKey: "password")
        user.setValue(phone, forKey: "phoneNumber")
        
        do {
            try managedContex.save()
            navigateToHomeScreen()
        }
        catch let error as NSError{
            print("Couldnot save: \(error), \(error.userInfo)")
        }
    }
    //Move to next textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
