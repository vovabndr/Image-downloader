//
//  CoreDataHelper.swift
//  Downloader
//
//  Created by Владимир Бондарь on 6/16/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper {
    private class func getContex() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return  NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)}
        return appDelegate.persistentContainer.viewContext
    }
    
    class func save(imageLink: String?, imageData: Data?, message: @escaping (String) -> Void) {
        guard let imageLink = imageLink,
            let imageData = imageData else {
                message("Bad data")
                return
        }
        
        if !check(imageLink: imageLink) {
            message("Already saved")
            return
        }
        let context = getContex()
        let entity = NSEntityDescription.entity(forEntityName: "ImageManagedObject", in: context)
        let newImage = NSManagedObject(entity: entity!, insertInto: context)
        
        newImage.setValue(imageLink, forKey: "link")
        newImage.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            message("Saved!")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func fetch(handle: @escaping ([NSManagedObject], [Image]) -> Void) {
        let context = getContex()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageManagedObject")
        request.returnsObjectsAsFaults = false
        
        do {
            if let results = try context.fetch(request) as? [NSManagedObject] {
                var imageList = [Image]()
                for result in results {
                    guard let link = result.value(forKey: "link") as? String,
                        let image = result.value(forKey: "image") as? Data else { return }
                    imageList.append(Image(link: link, image: image))
                }
                handle(results, imageList)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func delete(by index: Int) {
        let context = getContex()
        fetch { managed, _ in context.delete(managed[index]) }
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func check (imageLink: String?) -> Bool {
      var answer = Bool()
        fetch {
            if !$1.contains(where: {$0.link == imageLink}) {
                answer = true
            }
        }
        return answer
    }
    
}
