//
//  CoreDataManager.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
import UIKit
import CoreData

// MARK: - Manager(Helper) Class For Core Data
final class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Assignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Coredata saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    //MARK:- Insert the data into coredata
    func insertCountriesListintoCoreData(_ country: String){
        let countriesList = CountriesList(context:context)
        countriesList.countryName = country
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Error \(error), \(error.userInfo)")
        }
    }
    func insertStatisticsDataintoCoreData(_ modelContriesStatistics: ModelCountriesStatistics){
       let countriesStatistics = CountriesStatistics(context:context)
        countriesStatistics.modelCountriesStatistics = modelContriesStatistics
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Error \(error), \(error.userInfo)")
        }
    }
    //MARK:- Check record exists in coredata
    func checkForEntityExists(countryName: String) -> (Bool,[CountriesList]?) {
        let fetchRequest = CountriesList.fetchRequest() as NSFetchRequest<CountriesList>
        fetchRequest.predicate =  NSPredicate(format: "countryName = %@", countryName)
        var arrCountryList : [CountriesList]?
        do {
            arrCountryList = try context.fetch(fetchRequest)
        }
        catch {
            print("Error executing fetch request: \(error)")
        }
        return (arrCountryList?.count ?? 0 > 0,arrCountryList)
    }
    func checkForStatisticsEntityExists(id: String) -> (Bool,[CountriesStatistics]?) {
        let fetchRequest = CountriesStatistics.fetchRequest() as NSFetchRequest<CountriesStatistics>
        fetchRequest.predicate =  NSPredicate(format: "iD = %@", id)
        var arrCountryStatistics : [CountriesStatistics]?
        do {
            arrCountryStatistics = try context.fetch(fetchRequest)
        }
        catch {
            print("Error executing fetch request: \(error)")
        }
        return (arrCountryStatistics?.count ?? 0 > 0,arrCountryStatistics)
    }
    //MARK:- Fetch the records from coredata
    func fetchAllCountriesList() -> [CountriesList]?{
        let fetchRequest = CountriesList.fetchRequest() as NSFetchRequest<CountriesList>
        do {
            let arrCountriesList = try context.fetch(fetchRequest)
            return arrCountriesList
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func fetchCountriesStatisticsByCountryName(countryName: String) -> [CountriesStatistics]? {
        let fetchRequest = CountriesStatistics.fetchRequest() as NSFetchRequest<CountriesStatistics>
        fetchRequest.predicate =  NSPredicate(format: "countryName == %@", countryName)
        var arrCountryStatistics : [CountriesStatistics]?
        do {
            arrCountryStatistics = try context.fetch(fetchRequest)
        }
        catch {
            print("Error Could not fetch request: \(error)")
        }
        return arrCountryStatistics
    }
}
