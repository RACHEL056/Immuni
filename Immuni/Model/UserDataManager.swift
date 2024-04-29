//
//  UserDataManager.swift
//  Immuni
//
//  Created by 박민정 on 4/15/24.
//

import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "UserData")
    
    init(){
        container.loadPersistentStores { descriptoin, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
