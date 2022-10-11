//
//  AddProductViewController.swift
//  E-Library
//
//  Created by Majlinda - INNO on 17.9.22.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: TextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var priceTextField: TextField!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var fileURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.contentInset = UIEdgeInsets(top: 5, left: 11, bottom: 5, right: 11)
    }
    func uploadPhoto(){
        let editPicture = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takeApicture = UIAlertAction(title: "Take Photo", style: .default, handler: {
                                            (alert: UIAlertAction!) -> Void in self.openCamera() })
        let chooseFromCameraRoll = UIAlertAction(title: "Choose From Gallery", style: .default, handler: {
                                                    (alert: UIAlertAction!) -> Void in self.openPhotoLibraryButton() })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                                            (alert: UIAlertAction!) -> Void in })
        editPicture.addAction(takeApicture)
        editPicture.addAction(chooseFromCameraRoll)
        editPicture.addAction(cancelAction)
        //        editPicture.view.tintColor = Colors.dustyOrange
        
        if let popoverController = editPicture.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: 0, y: view.frame.size.height, width: self.view.frame.size.width, height: 200)
        }
        self.present(editPicture, animated: true, completion: nil)
    }
    func setupSelectedButton(selected: UIButton, deselected: UIButton){
        selected.backgroundColor = UIColor(hexString: "#F98E54")
        selected.setTitleColor(.white, for: .normal)
        deselected.backgroundColor = .white
        deselected.setTitleColor(UIColor(hexString: "#F98E54"), for: .normal)
    }
    func addData(){
        //add data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "AddBook", in: managedContex)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContex)
        user.setValue(titleTextField.text, forKey: "title")
        user.setValue(fileURL, forKey: "imageUrl")
        user.setValue(Double(priceTextField.text ?? ""), forKey: "price")
        user.setValue(descriptionTextView.text, forKey: "bookDesc")
        
        do {
            try managedContex.save()
            NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
        catch let error as NSError{
            print("Couldnot save: \(error), \(error.userInfo)")
        }
    }
    //MARK: - IBActions
    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageButtonPressed(_ sender: Any) {
        uploadPhoto()
    }
    @IBAction func addBookButtonPressed(_ sender: Any) {
        addData()
    }
    @IBAction func exchangeButtonPressed(_ sender: Any) {
        setupSelectedButton(selected: exchangeButton, deselected: sellButton)
        self.priceTextField.isHidden = true
    }
    @IBAction func sellButtonPressed(_ sender: Any) {
        setupSelectedButton(selected: sellButton, deselected: exchangeButton)
        self.priceTextField.isHidden = false
    }
}
extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
            self.fileURL = fileUrl?.absoluteString
            self.coverImageView.image = image
        }
        picker.dismiss(animated: true, completion: {
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
