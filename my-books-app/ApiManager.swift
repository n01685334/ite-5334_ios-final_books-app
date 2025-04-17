//
//  ApiManager.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/9.
//

import Foundation

protocol BookListApiDelegate {
    func didFinishGettingBookList(list: [BookVolume])
    func didFinishGettingBookDetail(book: BookVolume)
    func requestDidFail(with error: Error?)
}


class ApiManager {
    static var shared = ApiManager()
    
    var bookListApiDelegate: BookListApiDelegate?
    
    func printDebug(_ tag: String, message: String) {
        print("\(tag): \(message)")
    }

    
    func getBookSearchResults(searchTerm: String){
        let tag = "getBookSearchResults"
        let encodedSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+");
        print(encodedSearchTerm)
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedSearchTerm)&maxResults=40")!
        
        print(url)
        
        
        let task =  URLSession.shared.dataTask(with: url) { data, response, error in
            
        
            if error != nil {
                self.printDebug(tag, message: "Network error ocurred")
                self.bookListApiDelegate?.requestDidFail(with: error)
                return
            }
        

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("No usable response.")
                self.bookListApiDelegate?.requestDidFail(with: nil)
                return
            }
            
            // the data is ready
            guard let goodData = data else {
                DispatchQueue.main.async {
                    self.bookListApiDelegate?.requestDidFail(with: nil)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
//                if let responseString = String(data: goodData, encoding: .utf8) {
//                        print("Raw JSON: \(responseString)")
//                    }
                
//                let topLevel = try decoder.decode([String: Any].self, from: goodData) as? [String: Any]
//                print("top level decoded.")
                
                let decoded = try decoder.decode(BookSearchResponse.self, from: goodData)
                print("decoded successfully")
                let bookList = decoded.items;
                
                DispatchQueue.main.async {
                    self.bookListApiDelegate?.didFinishGettingBookList(list: bookList ?? [])
                }
                
            } catch {
                self.printDebug(tag, message: "decoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.bookListApiDelegate?.requestDidFail(with: error)
                }
            }
        }
        
        task.resume()
        
    }

    
}
