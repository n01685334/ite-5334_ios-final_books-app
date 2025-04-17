//
//  BookDetailViewController.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/11.
//

import UIKit

class BookDetailViewController: UIViewController {

    var currentBook: BookVolume?
    
    @IBOutlet weak var bookTitleText: UILabel!
    @IBOutlet weak var bookPageCountText: UILabel!
    @IBOutlet weak var bookAuthorText: UILabel!
    
    @IBOutlet weak var bookCategoriesText: UILabel!
    @IBOutlet weak var bookDateText: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var bookDescriptionText: UITextView!
    
    @IBAction func addBtn(_ sender: Any) {
        if let book = currentBook {
            CoreDataManager.shared.addNewBook(volume: book)
            let alert = UIAlertController(title: "Success", message: "Book added to your library", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let currentBook {
            bookTitleText?.text = currentBook.volumeInfo?.title ?? "unknown"
            bookAuthorText?.text = currentBook.volumeInfo?.authors?.joined(separator: ", ")
            bookDescriptionText?.text = currentBook.volumeInfo?.description ?? "No description available"
            
            var pageCount: String
             if let count = currentBook.volumeInfo?.pageCount {
                pageCount = "\(count)"
            } else {
                pageCount = "Unknown"
            }
            
            bookPageCountText?.text = "Pages: \(pageCount)"
            
            let categories = currentBook.volumeInfo?.categories?.joined(separator: ", ")
            bookCategoriesText?.text = "Categories: \(categories ?? "none")"
            
            bookDateText?.text = "Published: \(currentBook.volumeInfo?.publishedDate ?? "Unknown")"
            
            if let imageUrl = currentBook.volumeInfo?.imageLinks?.thumbnail {
                downloadImage(url: imageUrl)
            }
            
        }
    }
    
    func downloadImage (url: String) {
        print(url)
        
        let urlObj = URL(string: url)!
        let queue = DispatchQueue(label: "imageQueue")
        queue.async {
            do {
                let imageData = try Data(contentsOf:urlObj)// in background thread
                DispatchQueue.main.async {
                    self.bookCoverImage.image = UIImage(data: imageData)// in main thread
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
