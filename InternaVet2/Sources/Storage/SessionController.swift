//
//  UserDefaults.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

protocol SessionControllerManagerProtocol: class {
    weak var sessionController: SessionController! {get set}
}

extension SessionControllerManagerProtocol {
    func trySetSession(on vc: UIViewController) {
        if let session = self.sessionController {
            (vc as? SessionControllerManagerProtocol)?.sessionController = session
        }
    }
}

enum SessionControllerError: Error {
    case userAlreadyRegistered
    case userNotRegistered
}

class SessionController {
    private let context = StorageContext()
    
    private(set) var currentUser: User?
    private(set) var dogHousesNumber: Int = DefaultValues.numberOfDogHouses
    
    static var standard: SessionController = {
        let sc = SessionController()
        try? sc.registerUser(username: DefaultValues.standardUsername)
        let _ = try? sc.performLogin(username: DefaultValues.standardUsername)
        return sc
    }()
    
    @discardableResult
    func performLogin(username user: String) throws -> User {
        UserDefaults.standard.set(user, forKey: Keys.usernameKey)
        if let currentUser = self.loadUser(from: user) {
            self.currentUser = currentUser
            return currentUser
        }else {
            throw SessionControllerError.userNotRegistered
        }
    }
    
    func registerUser(username user: String) throws {
        if let _ = loadUser(from: user) {throw SessionControllerError.userAlreadyRegistered}
        let newUser = User()
        newUser.username = user
        newUser.dogHouses.append(contentsOf: Array(1...max(1,self.dogHousesNumber)).map({DogHouse($0)}))
        self.context.save(newUser)        
    }

    func saveContext() {
        if let user = self.currentUser {
            self.context.save(user)
        }
    }
    
    func resetContext() {
        if let currentUsername = self.currentUser?.username,
            let user = self.loadUser(from: currentUsername) {
            self.currentUser = user
        }
    }
    
    fileprivate func loadUser(from username: String) -> User? {
        return self.context.fetch(User.self, {$0.username == username}).first
    }
}
