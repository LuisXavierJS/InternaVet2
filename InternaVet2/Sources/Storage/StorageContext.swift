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

protocol NameableStorageItem: class {
    var fileName: String {get}
}

class StorageItem: NSObject {
    var xmlString: String = ""
    
    required init(_ xml: AEXMLDocument) {
        
    }
}

class AEXMLDocument: NSObject {
    var xmlString: String = ""
    
    init(xml: String) {
        
    }
}

class AEXMLElement: NSObject {
    var xmlString: String = ""
}

protocol Context: class {
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((String) -> Bool)) -> [Type] where Type: StorageItem, Type : NameableStorageItem
    
    func save<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem
    
    func delete<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem
    
    func count<Type>(_ type: Type.Type) -> Int where Type : StorageItem, Type: NameableStorageItem
}

class StorageContext: Context {
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem {
        return ContextFactory.new(type).fetch(type)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem {
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
    
    fileprivate func convert(_ path: Path) -> AEXMLDocument {
        return try! AEXMLDocument(xml: try! TextFile(path: path).read())
    }
    
    fileprivate func filter<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem {
        return self.path.children().filter({!$0.isDirectory && !$0.fileName.hasPrefix(".")}).map({ Type(self.convert($0)) })
    }
    
    func fetch<Type>(_ type: Type.Type) -> [Type] where Type : StorageItem {
        return self.filter(type)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((Type) -> Bool)) -> [Type] where Type : StorageItem {
        return self.filter(type).filter(isIncluded)
    }
    
    func fetch<Type>(_ type: Type.Type, _ isIncluded: ((String) -> Bool)) -> [Type] where Type : StorageItem, Type : NameableStorageItem {
        return self.path.children().filter({!$0.fileName.hasPrefix(".") && !$0.isDirectory && isIncluded($0.fileName)}).map({ Type(self.convert($0)) })
    }
    
    func save<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        let finalPath = self.path + (object.fileName + ".xml")
        
        #if DEBUG
            print("saving object: \(object.fileName) to path: ",finalPath)
        #endif
        
        try? self.path.createDirectory(withIntermediateDirectories: true)
        
        let fileText = TextFile(path: finalPath)
        try! fileText.write(object.xmlString, atomically: false)
        
        self.updateObjectHash(object)
    }
    
    func delete<Type>(_ object: Type) where Type : StorageItem, Type : NameableStorageItem {
        let finalPath = self.path + (object.fileName + ".xml")
        
        try? self.path.createDirectory(withIntermediateDirectories: true)
        
        let fileText = TextFile(path: finalPath)
        try! fileText.delete()
        
        self.updateObjectHash(nil)
    }
    
    func count<Type>(_ type: Type.Type) -> Int where Type : StorageItem, Type : NameableStorageItem {
        return self.path.children().filter({!$0.isDirectory}).count
    }
    
    fileprivate func updateObjectHash(_ object: StorageItem?) {
        _ = object?.perform("updateHash:", with: object?.xmlString.hashValue ?? -1)
    }
}

fileprivate class ContextFactory {
    fileprivate static let mainPath: Path = Path.userDocuments + "XML"
    
    static func new<Type>(_ type: Type.Type) -> RealStorageContext<Type> where Type : StorageItem {
        // TODO: setup username
        return RealStorageContext(self.getPath(type, self.mainPath))
    }
    
    fileprivate static func getPath<Type: StorageItem>(_ type: Type.Type, _ base: Path) -> Path where Type : StorageItem {
        switch type {
//        case is Session.Type: return base
//        case is Parameters.Type: return base + "username" + "Parametros"
//        case is RetailHierarchy.Type: return base + "username" + "Hierarquia de Venda"
//        case is Client.Type: return base + "username" + "Clientes"
//        case is EconomicGroup.Type: return base + "username" + "Clientes" + "Grupos Economicos"
//        case is Proposal.Type: return base + "username" + "Propostas"
//        case is LocalParameters.Type: return base + "Parametros Locais"
        default:
            assertionFailure("Tipo Não implementado \(type)")
        }
        return Path()
    }
}
