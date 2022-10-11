//
//  TableView.swift
//  E-Library
//
//  Created by Majlinda - INNO on 17.9.22.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: reuseIdentifier ?? String(describing: T.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                           for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        let nib = UINib(nibName: reuseIdentifier ?? String(describing: T.self), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                           for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        
        return cell
    }
}
