//
//  AppDelegate.swift
//  Todoey
//
//  Created by Pranav Mohan Joshi on 25/01/22.
//
//Explaination done in : - 34 the lecture of data persistance from angela u(last part of realm)

import UIKit
import CoreData
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        
        }catch {
            print("Error initiating new realm , \(error)")
        }
        return true
    }

}

