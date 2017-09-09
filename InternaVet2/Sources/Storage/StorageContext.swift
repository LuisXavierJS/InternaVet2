//
//  StorageContext.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

//
//  StorageContext.swift
//  PNE Mobile
//
//  Created by Anderson Lucas C. Ramos on 29/08/17.
//  Copyright © 2017 Radix Eng. All rights reserved.
//

import Foundation
import FileKit
import Swift_Json

func nameConstructor(title: String, attributes: [String:String]) -> String {
    return attributes.reduce(title + "…", { (result, dir) -> String in
        return result + "" + dir.key + "@" + dir.value
    })
}

protocol NameableStorageItem: class {
    var fileName: String {get}
    static func localPathOnStorage(from root: Path) -> Path
}

class StorageItem: NSObject {
    fileprivate(set) var originalHash: Int = 0
    
    var jsonString: String {
        return JsonWriter().write(anyObject: self)!
    }
    
}

protocol Context: class {
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem, Type: NameableStorageItem
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem, Type: NameableStorageItem
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((String) -> Bool)) -> [Type] where Type: StorageItem, Type : NameableStorageItem
    
    func save<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem
    
    func delete<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem
    
    func count<Type>(_ type: Type.Type) -> Int where Type : StorageItem, Type: NameableStorageItem
}

class StorageContext: Context {
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem, Type: NameableStorageItem {
        return ContextFactory.new(type).fetch(type)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem, Type: NameableStorageItem {
        return ContextFactory.new(type).fetch(type, isIncluded)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((String) -> Bool)) -> [Type] where Type: StorageItem, Type : NameableStorageItem {
        return ContextFactory.new(type).fetch(type, isIncluded)
    }
    
    func save<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        ContextFactory.new(object.classForCoder as! Type.Type).save(object)
    }
    
    func delete<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        ContextFactory.new(object.classForCoder as! Type.Type).delete(object)
    }
    
    func count<Type>(_ type: Type.Type) -> Int where Type : StorageItem, Type : NameableStorageItem {
        return ContextFactory.new(type).count(type)
    }
}

fileprivate class RealStorageContext<Type>: Context where Type : StorageItem {
    fileprivate var path: Path
    
    init(_ path: Path) {
        self.path = path
    }
    
    fileprivate func convert<Type>(_ path: Path) -> Type where Type: StorageItem {
        let object: Type! = JsonParser().parse(data: try! DataFile(path: path).read())
        object.originalHash = object.jsonString.hash
        return object
    }
    
    fileprivate func filter<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem {
        return self.path.children().filter({!$0.isDirectory && !$0.fileName.hasPrefix(".")}).map({ self.convert($0) })
    }
    
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem {
        return self.filter(type)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem {
        return self.filter(type).filter(isIncluded)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((String) -> Bool)) -> [Type] where Type : StorageItem, Type : NameableStorageItem {
        return self.path.children().filter({!$0.fileName.hasPrefix(".") && !$0.isDirectory && isIncluded($0.fileName)}).map({ self.convert($0) })
    }
    
    func save<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        let finalPath = self.path + (object.fileName + ".xml")
        
        #if DEBUG
            print("saving object: \(object.fileName) to path: ",finalPath)
        #endif
        
        try? self.path.createDirectory(withIntermediateDirectories: true)
        
        let fileText = TextFile(path: finalPath)
        try! fileText.write(object.jsonString, atomically: false)
        
//        self.updateObjectHash(object)
    }
    
    func delete<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        let finalPath = self.path + (object.fileName + ".xml")
        
        try? self.path.createDirectory(withIntermediateDirectories: true)
        
        let fileText = TextFile(path: finalPath)
        try! fileText.delete()
        
//        self.updateObjectHash(nil)
    }
    
    func count<Type>(_ type: Type.Type) -> Int where Type : StorageItem, Type : NameableStorageItem {
        return self.path.children().filter({!$0.isDirectory}).count
    }
    
}

fileprivate class ContextFactory {
    fileprivate static let mainPath: Path = Path.userDocuments + "XML"
    
    static func new<Type>(_ type: Type.Type) -> RealStorageContext<Type> where Type : StorageItem, Type: NameableStorageItem {
        // TODO: setup username
        return RealStorageContext(self.getPath(type, self.mainPath))
    }
    
    fileprivate static func getPath<Type: StorageItem>(_ type: Type.Type, _ base: Path) -> Path where Type : StorageItem, Type: NameableStorageItem {
        return type.localPathOnStorage(from: base)
    }
}
