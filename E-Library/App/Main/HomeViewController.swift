//
//  Home.swift
//  E-Library
//
//  Created by Majlinda - INNO on 17.9.22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Properties
    var booksList : [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupCollection()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadData"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }
    func setupTable(){
        self.tableView.register(MyBookCell.self)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    func setupCollection(){
        self.collectionView.register(TopBooksCell.self)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    func navigateToAddReview(objID: NSManagedObjectID?){
        let addReview : UIStoryboard = UIStoryboard(name: "AddReview", bundle:nil)
        let popUp = addReview.instantiateViewController(withIdentifier: "AddReviewViewController") as! AddReviewViewController
        popUp.objectID = objID
        present(popUp, animated: true, completion: nil)
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        retrieveData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 40)
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MyBookCell.self, for: indexPath)
        cell.titleLabel.text =  "\(booksList?[indexPath.row].value(forKey: "title") ?? "")"
        cell.descriptionLabel.text =  "\(booksList?[indexPath.row].value(forKey: "bookDesc") ?? "")"
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
        let id = self.booksList?[indexPath.row].objectID
        self.navigateToAddReview(objID: id)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(TopBooksCell.self, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 121, height: 170)
    }
}
