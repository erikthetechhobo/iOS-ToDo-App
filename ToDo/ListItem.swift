//  ListItem.swift
//  todo

import Foundation
import CoreData

//data model for list item, NSManagedObject allows it to be saved to phone, Identifiable gives
//each list item an unique id. name is a string, createdAt is a Swift date object
class ListItem: NSManagedObject, Identifiable {
    @NSManaged var name: String?
    @NSManaged var createdAt: Date?
}

//
extension ListItem {
    //creates function to fetch with NSFetchRequest with a context of the above list item.
    static func getAllListItems() -> NSFetchRequest<ListItem> {
        let request: NSFetchRequest<ListItem> = ListItem.fetchRequest() as! NSFetchRequest<ListItem>
        //variables are sorting themes
        let sortOldFirst = NSSortDescriptor(key: "createdAt", ascending: true)
        //let sortNewFirst = NSSortDescriptor(key: "createdAt", ascending: false)
        
        request.sortDescriptors = [sortOldFirst]
        
        return request
    }
}
