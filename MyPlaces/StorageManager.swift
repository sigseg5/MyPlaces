//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Kirill Parhomenko on 6.1.2020.
//  Copyright © 2020 Kirill Parhomenko. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
  static func saveObject(_ place: Place) {
    try! realm.write {
      realm.add(place)
    }
  }
  
  static func deleteObject(_ place: Place) {
    try! realm.write {
      realm.delete(place)
    }
  }
}
