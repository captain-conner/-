//
//  Models.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/24.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//


//数据库操作
import UIKit
import Foundation
import CoreData




final class SQL_CLASS {
    
    static let shared = SQL_CLASS()
    //实现底层的增删改查
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    

    
    
    //获取指定实体的所有数据
    func getEntity(entityName:String) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            print("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                //print("name:  \(p.value(forKey: "name")!) detail: \(p.value(forKey: "age")!)")
                print(p)
            }
            
            return (searchResults as! [NSManagedObject])
        } catch  {
            print(error)
            return []
        }
        
        
    }
    
    //查询符合name条件的数据
    func search(entityName:String,name:String) ->[NSManagedObject]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        
        //查询条件
        let condition = "name='\(name)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        
        do {
            
            let searchResults = try getContext().fetch(request)
            print(searchResults.count)
            for p in (searchResults as! [NSManagedObject]){
                //print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
                print(p)
            }
            
            return (searchResults as! [NSManagedObject])
            
        }catch  {
            print(error)
            return []
        }
    }
    
    
    //删除指定名字的实体的指定name数值字段
    func delete(entityName:String,name:String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let condition = "name='\(name)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        
        do {
            
            let searchResults = try getContext().fetch(request)
            for p in (searchResults as! [NSManagedObject]){
                //print("删除 name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
                //...............delete
                context.delete(p)
                try context.save()
            }
            
        }catch  {
            print(error)
        }
    }
    
    
    //改 根据指定entity和 对entity 进行name查询，再对 参数字段修改
    func upDateEntity(entityName:String,name:String,argument:NSDictionary) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        let condition = "name='\(name)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        
        do {
            //...............update,更新所有名字符合要求的age
            let searchResults = try getContext().fetch(request)
            for p in (searchResults as! [NSManagedObject]){
                
                switch entityName {
                case "MOTIONS":
                    let motionName = argument.value(forKey: "name")
                    let detail = argument.value(forKey: "detail")
                    let category = argument.value(forKey: "category")
                    p.setValue(motionName, forKey: "name")
                    p.setValue(detail, forKey: "detail")
                    p.setValue(category, forKey: "category")
                case "PROJECT":
                    let projectName = argument.value(forKey: "name")
                    let interval = argument.value(forKey: "interval")
                    let loop =  argument.value(forKey: "loop")
                    p.setValue(projectName, forKey: "name")
                    p.setValue(interval, forKey: "interval")
                    p.setValue(loop, forKey: "loop")
                    
                case "STEP":
                    let times = argument.value(forKey: "times")
                    let counts = argument.value(forKey: "counts")
                    let rank = argument.value(forKey: "rank")
                    p.setValue(times, forKey: "times")
                    p.setValue(counts, forKey: "counts")
                    p.setValue(rank, forKey: "rank")
                    
                case "TIMEKEEPER":
                    let times = argument.value(forKey: "times")
                    p.setValue(times, forKey: "times")
                    p.setValue(name, forKey: "name")

                default: break
                    
                }
                
              
                try context.save()
            }
            
        }catch  {
            print(error)
        }
        
    }
    
    //插入
    func storeEntity(entityName:String,argument:NSDictionary)  {
        let context = getContext()
        //定义实体entity 要在 coredata 中存在
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let MO = NSManagedObject(entity: entity!, insertInto: context)
        
        switch entityName {
        case "MOTIONS":
            print("开始插入")
            let name = argument.value(forKey: "name")
            let detail = argument.value(forKey: "detail")
            let category = argument.value(forKey: "category")
            MO.setValue(name, forKey: "name")
            MO.setValue(detail, forKey: "detail")
            MO.setValue(category, forKey: "category")
        case "PROJECT":
            let name = argument.value(forKey: "name")
            let loop = argument.value(forKey: "loop")
            let interval = argument.value(forKey: "interval")
            let resttime = argument.value(forKey: "resttime")
            MO.setValue(name, forKey: "name")
            MO.setValue(loop, forKey: "loop")
            MO.setValue(interval, forKey: "interval")
            MO.setValue(resttime, forKey: "resttime")
        case "STEP":
            let name = argument.value(forKey: "name")
            let belong = argument.value(forKey: "belong")
            let times = argument.value(forKey: "times")
            let rank = argument.value(forKey: "rank")
            let counts = argument.value(forKey: "counts")
            MO.setValue(name, forKey: "name")
            MO.setValue(belong, forKey: "belong")
            MO.setValue(times, forKey: "times")
            MO.setValue(rank, forKey: "rank")
            MO.setValue(counts, forKey: "counts")
        case "TIMEKEEPER":
            let name = argument.value(forKey: "name")
            let times = argument.value(forKey: "times")
            MO.setValue(name, forKey: "name")
            MO.setValue(times, forKey: "times")
        default: break
            
        }

        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    
    //特殊方法，step表专用
    func searchBelong(entityName:String,name:String) ->[NSManagedObject]{
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        
        //查询条件,这里专门搜索belong段
        let condition = "belong='\(name)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        
        do {
            
            let searchResults = try getContext().fetch(request)
            print(searchResults.count)
            for p in (searchResults as! [NSManagedObject]){
                //print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
                print(p)
            }
            
            return (searchResults as! [NSManagedObject])
            
        }catch  {
            print(error)
            return []
        }
    }
    
    //根据 所属和 排位删除setp表内容
    func upDateBy_BelongandRank(name:String,belong:String,times:Int,counts:Int,rank:Int,newRank:Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "STEP")
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "STEP", in: context)
        
        //belong='\(name)'AND
        let condition = "rank=\(rank) and belong='\(belong)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        
        do {
            //...............update,更新所有名字符合要求的age
            let searchResults = try getContext().fetch(request)
            print("update结果搜索\(searchResults.count)")
            for p in (searchResults as! [NSManagedObject]){
                    p.setValue(times, forKey: "times")
                    p.setValue(counts, forKey: "counts")
                    p.setValue(newRank, forKey: "rank")
                try context.save()
            }
            
        }catch  {
            print(error)
        }

    }
    
    //根据名字和所属,和排位  删除step表中内容
    func deleteBy_NameandBelong(name:String,belong:String,rank:Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "STEP")
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "STEP", in: context)
        
        let condition = "name='\(name)' and belong='\(belong)' and rank=\(rank)"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        
        
        do {
            
            let searchResults = try getContext().fetch(request)
            print("update结果搜索\(searchResults.count)")
            for p in (searchResults as! [NSManagedObject]){
                context.delete(p)
                try context.save()
            }
            
        }catch  {
            print(error)
        }
    }
    
    //根据特定的区域属性进行搜索
    func searchProperty(entityName:String,propertyName:String,propertyValue:String) ->[NSManagedObject]{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        
        //查询条件
        let condition = "\(propertyName)='\(propertyValue)'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        //request.propertiesToFetch = ["category"]
        //request.propertiesToGroupBy = ["category"]
    
        //request.returnsDistinctResults = true
        
        do {
            
            let searchResults = try getContext().fetch(request)
            print(searchResults.count)
            for p in (searchResults as! [NSManagedObject]){
                //print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
                print(p)
            }
            
            return (searchResults as! [NSManagedObject])
            
        }catch  {
            print(error)
            return []
        }
    }
    
    


}
