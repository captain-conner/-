//
//  MyEntity.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/24.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import Foundation
//----------------------MOTIONS------------------
class MOTION_LIST {
    
    let sql = SQL_CLASS.shared
    var results:[NSDictionary] = [NSDictionary]()
    
    //getall ->[NSDictionary]
    func getMotions() ->[NSDictionary] {
        print("获取motion表所有内容")
        let objs = sql.getEntity(entityName: "MOTIONS")
        self.results = [NSDictionary]()
        for p in objs {
            
            let detail = p.value(forKey: "detail") as! String
            let name = p.value(forKey: "name") as! String
            let category = p.value(forKey: "category") as! String
            let dic:NSDictionary = NSDictionary(objects: [name,detail,category], forKeys: ["name" as NSCopying,"detail" as NSCopying,"category" as NSCopying])
            self.results.append(dic)
            
        }
        
        return (self.results)
    }
    //search ->[NSDictionary]
    func search(name:String) ->[NSDictionary]{
        print("搜索motion表")
       
        let objs =  sql.search(entityName: "MOTIONS", name: name)
        self.results = [NSDictionary]()
        for p in objs {
            
            let detail = p.value(forKey: "detail") as! String
            let name = p.value(forKey: "name") as! String
            let category = p.value(forKey: "category") as! String
            let dic:NSDictionary = NSDictionary(objects: [name,detail,category], forKeys: ["name" as NSCopying,"detail" as NSCopying,"category" as NSCopying])
            self.results.append(dic)
        }
        
        return (self.results)
    }
    
    
    func searchProperty(propertyName:String,propertyValue:String) ->[NSDictionary]{
        let objs =  sql.searchProperty(entityName: "MOTIONS", propertyName: propertyName, propertyValue: propertyValue)
        self.results = [NSDictionary]()
        for p in objs {
            
            let detail = p.value(forKey: "detail") as! String
            let name = p.value(forKey: "name") as! String
            let category = p.value(forKey: "category") as! String
            let dic:NSDictionary = NSDictionary(objects: [name,detail,category], forKeys: ["name" as NSCopying,"detail" as NSCopying,"category" as NSCopying])
            self.results.append(dic)
        }
        
        return (self.results)
    }
    
    //insert
    func insert(name:String,detail:String,category:String) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(detail, forKey: "detail")
        dic.setValue(category, forKey: "category")
        sql.storeEntity(entityName: "MOTIONS", argument: dic)
    }
    //delete
    func delete(name:String) {
        sql.delete(entityName: "MOTIONS", name: name)
        print("删除完毕")
    }
    //update
    func update(name:String,detail:String,category:String) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(detail, forKey: "detail")
        dic.setValue(category, forKey: "category")
        sql.upDateEntity(entityName: "MOTIONS", name: name, argument: dic)
        print("更新完毕")
    }
}


//--------------------PROJECT----------------------
class PROJECT_LIST {
    let sql = SQL_CLASS.shared
    var results:[NSDictionary] = [NSDictionary]()
    
    //get all
    func getPROJECTS()  ->[NSDictionary]{
        print("获取project表所有内容")
        self.results = [NSDictionary]()
        let objs = sql.getEntity(entityName: "PROJECT")
        
        for p in objs {
            
            let loop = p.value(forKey: "loop") as! Int
            let name = p.value(forKey: "name") as! String
            let interval = p.value(forKey: "interval") as! Int
            let dic:NSDictionary = NSDictionary(objects: [name,loop,interval], forKeys: ["name" as NSCopying,"loop" as NSCopying,"interval" as NSCopying])
            self.results.append(dic)
        }
        
        return (self.results)
    }

    //search
    func search(name:String) ->[NSDictionary]{
        print("搜索project表")
        
        self.results = [NSDictionary]()
        let objs = sql.search(entityName: "PROJECT", name: name)
        
        for p in objs {
            
            let loop = p.value(forKey: "loop") as! Int
            let name = p.value(forKey: "name") as! String
            let interval = p.value(forKey: "interval") as! Int
            let resttime = p.value(forKey: "resttime") as! Int
            let dic:NSDictionary = NSDictionary(objects: [name,loop,interval,resttime], forKeys: ["name" as NSCopying,"loop" as NSCopying,"interval" as NSCopying,"resttime" as NSCopying])
            self.results.append(dic)
        }
        
        return (self.results)
    }
    //insert
    func insert(name:String,interval:Int,loop:Int,resttime:Int) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(interval, forKey: "interval")
        dic.setValue(loop, forKey: "loop")
        dic.setValue(resttime, forKey: "resttime")
        sql.storeEntity(entityName: "PROJECT", argument: dic)
    }
    //delete
    func delete(name:String) {
        sql.delete(entityName: "PROJECT", name: name)
        print("删除完毕")
    }
    //update
    func update(name:String,interval:Int,loop:Int,resttime:Int) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(interval, forKey: "interval")
        dic.setValue(loop, forKey: "loop")
        dic.setValue(resttime, forKey: "resttime")
        sql.upDateEntity(entityName: "PROJECT", name: name, argument: dic)
        print("更新完毕")
    }


}


//------------------STEP---------------------
class STEP_LIST {
    
    let sql = SQL_CLASS.shared
    var results:[NSDictionary] = [NSDictionary]()
    
    //get all
    func getSTEP() ->[NSDictionary] {
        print("获取STEP表所有内容")
        self.results = [NSDictionary]()
        let objs = sql.getEntity(entityName: "STEP")
        
        for p in objs {
            
            let belong = p.value(forKey: "belong") as! String
            let name = p.value(forKey: "name") as! String
            let times = p.value(forKey: "times") as! Int
            let rank = p.value(forKey: "rank") as! Int
            let counts = p.value(forKey: "counts") as! Int
            let dic:NSDictionary = NSDictionary(objects: [name,belong,times,rank,counts], forKeys: ["name" as NSCopying,"belong" as NSCopying,"times" as NSCopying,"rank" as NSCopying,"counts" as NSCopying])
            self.results.append(dic)
        }
        
        return self.results

    }
    
    //search ，根据belong来搜索，这里的name 就是belong参数
    func searchBelong(name:String) ->[NSDictionary]{
        print("搜索STEP表")
        
        self.results = [NSDictionary]()
        let objs = sql.searchBelong(entityName: "STEP", name: name)
        
        for p in objs {
            
            let belong = p.value(forKey: "belong") as! String
            let name = p.value(forKey: "name") as! String
            let times = p.value(forKey: "times") as! Int
            let rank = p.value(forKey: "rank") as! Int
            let counts = p.value(forKey: "counts") as! Int
            let dic:NSDictionary = NSDictionary(objects: [name,belong,times,rank,counts], forKeys: ["name" as NSCopying,"belong" as NSCopying,"times" as NSCopying,"rank" as NSCopying,"counts" as NSCopying])
            self.results.append(dic)
        }
        
        return self.results
    }
    //insert
    func insert(name:String,belong:String,times:Int,counts:Int,rank:Int) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(belong, forKey: "belong")
        dic.setValue(times, forKey: "times")
        dic.setValue(counts, forKey: "counts")
        dic.setValue(rank, forKey: "rank")
        sql.storeEntity(entityName: "STEP", argument: dic)
    }
    //delete
    func delete(name: String, belong: String, rank: Int) {
        sql.deleteBy_NameandBelong(name: name, belong: belong, rank: rank)
        print("删除完毕")
    }
    //update 这的update要根据belong来update
    func update(name:String,belong:String,times:Int,counts:Int,rank:Int,newRank:Int) {
        
        sql.upDateBy_BelongandRank(name: name, belong: belong, times: times, counts: counts, rank: rank, newRank: newRank)
        print("更新完毕")
    }

}

//---------------TIMEKEEPER---------------
class TIMEKEEPER_LIST {

    //get all
    let sql = SQL_CLASS.shared
    var results:[NSDictionary] = [NSDictionary]()
    
    
    
    func getTIMEKEEPER()  -> [NSDictionary]{
        
        print("获取TIMEKEEPER_LIST表所有内容")
        self.results = [NSDictionary]()
        let objs = sql.getEntity(entityName: "TIMEKEEPER")
        
        for p in objs {
            
            let times = p.value(forKey: "times") as! Int
            let name = p.value(forKey: "name") as! String
            let dic:NSDictionary = NSDictionary(objects: [name,times], forKeys: ["name" as NSCopying,"times" as NSCopying])
            
            self.results.append(dic)
        }
        print(self.results.count)
        return self.results
        
    }
    
    //search
    func search(name:String) ->[NSDictionary]{
        print("搜索TIMEKEEPER_LIST表")
        
        self.results = [NSDictionary]()
        let objs = sql.search(entityName: "TIMEKEEPER", name: name)
        
        for p in objs {
            
            let times = p.value(forKey: "times") as! Int
            let name = p.value(forKey: "name") as! String
            let dic:NSDictionary = NSDictionary(objects: [name,times], forKeys: ["name" as NSCopying,"times" as NSCopying])
            
            self.results.append(dic)
        }
        
        return self.results
    }
    //insert
    func insert(name:String,times:Int32) {
        let dic = NSMutableDictionary()
        dic.setValue(name, forKey: "name")
        dic.setValue(times, forKey: "times")
        sql.storeEntity(entityName: "TIMEKEEPER", argument: dic)
    }
    //delete
    func delete(name:String) {
        sql.delete(entityName: "TIMEKEEPER", name: name)
        print("删除完毕")
    }
    //update 这的update要根据belong来update
    func update(name:String,times:Int32) {
        let dic = NSMutableDictionary()
        dic.setValue(times, forKey: "times")
        sql.upDateEntity(entityName: "TIMEKEEPER", name: name, argument: dic)
        print("更新完毕")
    }

    
}

