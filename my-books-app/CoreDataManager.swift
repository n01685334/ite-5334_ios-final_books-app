//
//  CoreDataManager.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/17.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "my_books_app")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Failed to load Core Data stack: \(error)")
                }
            }
            return container
        }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func addNewBook(volume: BookVolume) {
        let book = NSEntityDescription.insertNewObject(forEntityName: "UserBook", into: context) as! UserBook
        
        book.bookId = volume.id
        book.title = volume.volumeInfo?.title
        book.authors = volume.volumeInfo?.authors?.joined(separator: ", ")
        book.desc = volume.volumeInfo?.description
        book.pageCount = Int16(volume.volumeInfo?.pageCount ?? 0)
        book.publishedDate = volume.volumeInfo?.publishedDate
        book.categories = volume.volumeInfo?.categories?.joined(separator: ", ")
        book.thumbnailUrl = volume.volumeInfo?.imageLinks?.thumbnail
        book.currentPage = 0
        
        saveContext()
    }
    
    func getAllBooks() -> [UserBook] {
        let fetchRequest = UserBook.fetchRequest()
        
        do {
            let books = try context.fetch(fetchRequest)
            return books
        } catch {
            print("Error fetching books: \(error)")
            return []
        }
    }
    
    func updateBookProgress(book: UserBook, currentPage: Int16) {
        book.currentPage = currentPage
        saveContext()
    }
    
    func deleteBook(book: UserBook) {
        context.delete(book)
        saveContext()
    }
}
