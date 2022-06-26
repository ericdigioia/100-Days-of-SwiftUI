//
//  CachedFriend+CoreDataProperties.swift
//  CoreDataChallenge_v2
//
//  Created by Eric Di Gioia on 6/1/22.
//
//

import Foundation
import CoreData


extension CachedFriend {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var relationship: CachedUser?

}

extension CachedFriend : Identifiable {

}
