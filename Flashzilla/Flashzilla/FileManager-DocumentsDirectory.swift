//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Eric Di Gioia on 6/10/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
