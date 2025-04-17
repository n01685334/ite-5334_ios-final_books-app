//
//  LibraryTableViewController.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/17.
//

import UIKit

class LibraryTableViewController: UITableViewController {
    
    var savedBooks: [UserBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBooks()
    }
    
    func loadBooks() {
        savedBooks = CoreDataManager.shared.getAllBooks()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedBooks.count > 0 ? savedBooks.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "librarycell", for: indexPath)
        
        if savedBooks.count > 0 {
            let book = savedBooks[indexPath.row]
            cell.textLabel?.text = book.title
            cell.detailTextLabel?.text = book.authors
        } else {
            cell.textLabel?.text = "No saved books"
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && savedBooks.count > 0 {
            let book = savedBooks[indexPath.row]
            CoreDataManager.shared.deleteBook(book: book)
            loadBooks()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userBookSegue" {
            if let detailVC = segue.destination as? UserBookViewController,
               let indexPath = tableView.indexPathForSelectedRow,
               savedBooks.count > 0 {
                detailVC.book = savedBooks[indexPath.row]
            }
        }
    }
}

