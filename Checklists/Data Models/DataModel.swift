//
//  DataModel.swift
//  Checklists
//
//  Created by Ryan Chevarria on 3/5/22.
//

import Foundation

class DataModel{
    var lists = [Checklist]()
    
    init (){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //Loading and Saving methods
    
    func documentsDirectory() -> URL {
      let paths = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask)
      return paths[0]
    }
    
    func dataFilePath() -> URL {
      return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //SAVING
    
    func saveChecklists() {
      // 1
      let encoder = PropertyListEncoder()
      // 2
      do {
    // 3
          let data = try encoder.encode(lists)
        // 4
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
        // 5
    } catch { // 6
        print("Error encoding list array: \(error.localizedDescription)")
    } }
     
    //LOADING
    
    func loadChecklists() {
      // 1
      let path = dataFilePath()
      // 2
      if let data = try? Data(contentsOf: path) {
    // 3
        let decoder = PropertyListDecoder()
        do {
    // 4
            lists = try decoder.decode([Checklist].self, from: data)
            sortChecklists()
        } catch {
          print("Error decoding list array: \(error.localizedDescription)")
        }
      }
    }

    func registerDefaults(){
        let dictionary = [
            "ChecklistIndex": -1,
            "FirstTime": true
        ] as [String : Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //Computer property example:
    var indexOfSelectedChecklist: Int {
      get {
        return UserDefaults.standard.integer(
          forKey: "ChecklistIndex")
    } set {
        UserDefaults.standard.set(
          newValue,
          forKey: "ChecklistIndex")
    } }
    
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime{
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    
    func sortChecklists(){
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    //Class function allows you to call methods on an object even when you dont have a reference to that object
    
    class func nextChecklistItemID() -> Int{
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
    
    
}
