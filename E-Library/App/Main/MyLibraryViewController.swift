//
//  MyLibraryViewController.swift
//  E-Library
//
//  Created by Majlinda - INNO on 17.9.22.
//

import UIKit
import CoreData

class MyLibraryViewController: UIViewController {

    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var booksList : [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadData"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        retrieveData()
        self.scrollToBottom()
    }
    func scrollToBottom(){
        guard let booksList = booksList else {return}
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: booksList.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func setupTable(){
        self.tableView.register(MyBookCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    func navigateToAddBook(){
        let addDestinationStoryboard : UIStoryboard = UIStoryboard(name: "AddProduct", bundle:nil)
        let popUp = addDestinationStoryboard.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        present(popUp, animated: true, completion: nil)
    }
    func retrieveData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContex = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddBook")
        do{
            let results = try managedContex.fetch(request)
            self.booksList = results as? [NSManagedObject]
            self.tableView.reloadData()
            if let booksList = booksList, booksList.count != 0 {
                self.emptyView.isHidden = true
            }
            else{
                self.emptyView.isHidden = false
            }
        }
        catch{
            print("failed")
        }
    }
    //IBActions
    @IBAction func addButtonPressed(_ sender: Any) {
        self.navigateToAddBook()
    }
}

extension MyLibraryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MyBookCell.self, for: indexPath)
        cell.titleLabel.text =  "\(booksList?[indexPath.row].value(forKey: "title") ?? "")"
        cell.descriptionLabel.text =  "\(booksList?[indexPath.row].value(forKey: "bookDesc") ?? "")"
        if let img = booksList?[indexPath.row].value(forKey: "imageUrl"){
            cell.coverImageView.setImage(with: "\(img)")
        }
        if let price = booksList?[indexPath.row].value(forKey: "price"){
            cell.priceLabel.text =  "\(price)€"
        }
        else{
            cell.priceLabel.text = "Exchange"
            cell.priceLabel.textColor = UIColor(hexString: "#15a065")
        }
        if let rating = booksList?[indexPath.row].value(forKey: "rating") as? Double{
            cell.ratingView.rating = rating
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
