//
//  CoreDataHelper.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import Foundation
import CoreData
//
import UIKit
//
class CoreDataHelper {
    
    private class func getContex() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    class func save(imageLink: String?, imageData: Data? ){
        
        guard let imageLink = imageLink, let imageData = imageData else { return  }
        
        let context = getContex()
        let entity = NSEntityDescription.entity(forEntityName: "ImageManagedObject", in: context)
        let newImage = NSManagedObject(entity: entity!, insertInto: context)
        
        newImage.setValue(imageLink, forKey: "link")
        newImage.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            print("save")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func fetch(handle: @escaping ([NSManagedObject],[Image]) -> Void){
        let context = getContex()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageManagedObject")
        request.returnsObjectsAsFaults = false
        
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                var imageList = [Image]()
                for result in results {
                    imageList.append(Image(link: result.value(forKey: "link") as! String,
                                           image: result.value(forKey: "image") as! Data))
                }
                handle(results, imageList)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func delete(by index: Int){
        
        
        let context = getContex()
        fetch { managed, _ in context.delete(managed[index]) }
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
