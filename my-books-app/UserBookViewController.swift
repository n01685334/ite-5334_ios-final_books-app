//
//  UserBookViewController.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/17.
//

import UIKit

class UserBookViewController: UIViewController {
    
    var book: UserBook?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var pageTextField: UITextField!
    @IBOutlet weak var updateProgressButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let book = book else { return }
        
        titleLabel.text = book.title
        authorLabel.text = book.authors
        descriptionTextView.text = book.desc
        pageCountLabel.text = "Total pages: \(book.pageCount)"
        pageTextField.text = "\(book.currentPage)"
        progressView.progress = book.pageCount > 0 ? Float(book.currentPage) / Float(book.pageCount) : 0

        updateProgressLabel()
        
        if let imageUrl = book.thumbnailUrl, let url = URL(string: imageUrl) {
            downloadImage(url: imageUrl)
        }
    }
    
    func updateProgressLabel() {
        guard let book = book else { return }
        
        let progress = Int(book.currentPage)
        let total = Int(book.pageCount)
        let percentage = total > 0 ? Int((Float(progress) / Float(total)) * 100) : 0
        
        progressLabel.text = "Progress: \(progress)/\(total) pages (\(percentage)%)"
    }
    
    @IBAction func deleteBook(_ sender: Any) {
        guard let book = book else {return}
        
        let alert = UIAlertController(
                title: "Delete Book",
                message: "Are you sure you want to remove this book from your library?",
                preferredStyle: .alert
            )
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                
                CoreDataManager.shared.deleteBook(book: book)
                
                let confirmationAlert = UIAlertController(
                    title: "Book Deleted",
                    message: "The book has been removed from your library",
                    preferredStyle: .alert
                )
            
                confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.navigationController?.popViewController(animated: true)
                })
                
                self?.present(confirmationAlert, animated: true)
            })
            
            present(alert, animated: true)
    }
    
    @IBAction func updateProgress(_ sender: Any) {
        guard let book = book else { return }
        
        guard let pageText = pageTextField.text, !pageText.isEmpty else {
            showAlert(message: "Please enter a page number")
            return
        }
        
        guard let pageNumber = Int16(pageText) else {
            showAlert(message: "Please enter a valid number")
            return
        }
        
        if pageNumber < 0 {
            showAlert(message: "Page number must be positive")
            return
        }
        
        if pageNumber > book.pageCount {
            showAlert(message: "Page number cannot exceed total pages (\(book.pageCount))")
            return
        }
        
        
        book.currentPage = pageNumber
        
        
        progressView.progress = book.pageCount > 0 ? Float(book.currentPage) / Float(book.pageCount) : 0
        updateProgressLabel()
        
        
        CoreDataManager.shared.updateBookProgress(book: book, currentPage: book.currentPage)
        
        showAlert(message: "Reading progress saved", title: "Success")
    }
    
    func showAlert(message: String, title: String = "Error") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func saveProgress(_ sender: Any) {
        guard let book = book else { return }
        
        CoreDataManager.shared.updateBookProgress(book: book, currentPage: book.currentPage)
        
        let alert = UIAlertController(title: "Success", message: "Reading progress saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func downloadImage (url: String) {
        print(url)
        
        let urlObj = URL(string: url)!
        let queue = DispatchQueue(label: "imageQueue")
        queue.async {
            do {
                let imageData = try Data(contentsOf:urlObj)// in background thread
                DispatchQueue.main.async {
                    self.coverImageView.image = UIImage(data: imageData)// in main thread
                }
            }
            catch {
                print(error)
            }
        }
    }
    
}
