//
//  ViewModel.swift
//  FilmLoctions
//
//  Created by Neil Li on 12/12/17.
//  Copyright © 2017 Li Zezhong. All rights reserved.
//
//  ViewModel of main ViewController
//  Providing model data by calling MovieClient to fetch data.
//  Stores data after fetching. Then always return data from DB.
//  Providing methods to return specific data.
//  Providing methods to sort data.
//
//  Dependency on MovieClient which is injected and initialized by storyboard.
//

import UIKit
import CoreData

class ViewModel: NSObject {
    @IBOutlet var movieClient : MovieClient!
    private var movies : [NSManagedObject]?
    
    // MARK: Data for indexPath
    func numberOfItemsInSection(section : Int) -> Int {
        return movies?.count ?? 0
    }
    func nameAtIndexPath(indexPath : IndexPath) -> String {
        return movies?[indexPath.row].value(forKeyPath: "name") as? String ?? ""
    }
    func yearAtIndexPath(indexPath : IndexPath) -> String {
        return movies?[indexPath.row].value(forKeyPath: "year") as? String ?? ""
    }
    func locationAtIndexPath(indexPath : IndexPath) -> String {
        return movies?[indexPath.row].value(forKeyPath: "location") as? String ?? ""
    }
    
    // MARK: Fetching data from Server/Core Data
    func fetchMovies(completion: @escaping () -> ()) {
        fetchFromDB()
        if movies != nil && movies!.count > 0 {
            return
        }
        unowned let unownedSelf = self
        movieClient.fetchMovies(completion: { (array) in
            guard let array = array else {
                completion()
                return
            }
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            for m in array {
                let m = m as! Array<Any>
                let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
                let movie = NSManagedObject(entity: entity, insertInto: managedContext)
                movie.setValue(m[8] as? String ?? "", forKeyPath: "name")
                movie.setValue(m[9] as? String ?? "", forKeyPath: "year")
                movie.setValue(m[10] as? String ?? "", forKeyPath: "location")
                do {
                    try managedContext.save()
                    unownedSelf.movies?.append(movie)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            completion()
        })
    }
    
    private func fetchFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        do {
            movies = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: Sorting methods
    func sortMoviesByYear(_ asc : Bool) {
        movies?.sort(by: { (objOne, objTwo) -> Bool in
            let oneYear = objOne.value(forKeyPath: "year") as? String ?? ""
            let twoYear = objTwo.value(forKeyPath: "year") as? String ?? ""
            if asc {
                 return oneYear < twoYear
            }
            else {
                return oneYear > twoYear
            }
        })
    }
    
    func sortMoviesByName(_ asc : Bool) {
        movies?.sort(by: { (objOne, objTwo) -> Bool in
            let oneName = objOne.value(forKeyPath: "name") as? String ?? ""
            let twoName = objTwo.value(forKeyPath: "name") as? String ?? ""
            if asc {
                return oneName < twoName
            }
            else {
                return oneName > twoName
            }
        })
    }
}






