//
//  UserBook+CoreDataProperties.swift
//  my-books-app
//
//  Created by James Chard on 2025/4/17.
//
//

import Foundation
import CoreData


extension UserBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserBook> {
        return NSFetchRequest<UserBook>(entityName: "UserBook")
    }

    @NSManaged public var bookId: String?
    @NSManaged public var title: String?
    @NSManaged public var authors: String?
    @NSManaged public var desc: String?
    @NSManaged public var pageCount: Int16
    @NSManaged public var currentPage: Int16
    @NSManaged public var publishedDate: String?
    @NSManaged public var categories: String?
    @NSManaged public var thumbnailUrl: String?

}

extension UserBook : Identifiable {

}
