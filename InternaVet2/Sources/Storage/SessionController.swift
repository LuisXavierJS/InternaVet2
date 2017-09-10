//
//  UserDefaults.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

class SessionController {
    static private let usernameKey: String = "lastLoggedUser"
    static let context = StorageContext()
    
    static private(set) var currentUser: User?
    
    static var currentUsername: String? {
        return UserDefaults.standard.value(forKey: usernameKey) as? String
    }
    
    @discardableResult
    static func performLogin(username user: String) -> User? {
        UserDefaults.standard.set(user, forKey: usernameKey)
        self.currentUser = self.loadUser(from: user)
        return self.currentUser
    }
    
    @discardableResult
    static func registerUser(username user: String) -> Bool {
        if let _ = loadUser(from: user) {return false}
        let newUser = User()
        newUser.username = user
        User.resetDogHousesToDefault(onUser: newUser)
        self.context.save(newUser)
        return true
    }

    private static func loadUser(from username: String) -> User? {
        return self.context.fetch(User.self, {$0.username == username}).first
    }
}
