//
//  BookSearchController.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/9.
//

import UIKit

class BookSearchController: UIViewController, BookListApiDelegate, UITableViewDelegate, UITableViewDataSource {
    func didFinishGettingBookDetail(book: BookVolume) {
    
    }
    
    var searchResultList: [BookVolume] = []
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchField: UITextField!
    
    func didFinishGettingBookList(list: [BookVolume]) {
//        print("got books: \(list.count)")
//        for book in list {
//            print("\(book.volumeInfo?.title ?? "unknown title")")
//        }
        self.searchResultList = list
        searchTableView.reloadData()
    }
    
    func requestDidFail(with error: Error?) {
        print("request failed: \(error?.localizedDescription ?? "")")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count > 0 ? searchResultList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath)
        
        if(searchResultList.count > 0) {
            cell.textLabel?.text = searchResultList[indexPath.row].volumeInfo?.title ?? "Unknown title"
            cell.detailTextLabel?.text = searchResultList[indexPath.row].volumeInfo?.authors?.joined(separator: ", ") ?? "Unknown authors"

        } else {
            cell.textLabel?.text = "No books found"
            cell.detailTextLabel?.text = nil
        }
        
        return cell
        
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let query = searchField.text ?? ""
        
        print("query: \(query)")
        
        if(!query.isEmpty) {
            ApiManager.shared.getBookSearchResults(searchTerm: query)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiManager.shared.bookListApiDelegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "bookDetailSegue") {
           if let bookDetailVC = segue.destination as? BookDetailViewController {
                if let indexPath = searchTableView.indexPathForSelectedRow {
                    let book = searchResultList[indexPath.row]
                    bookDetailVC.currentBook = book
                    bookDetailVC.title = book.volumeInfo?.title
                }
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
