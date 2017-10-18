//
//  UserDefaults.swift
//  InternaVet2
//
//  Created by Jorge Luis on 09/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation

class SessionController {
    private let context = StorageContext()
    private(set) var currentUser: User?
    
    static var standard: SessionController = {
        let sc = SessionController()
        return sc
    }()
    
    @discardableResult
    func performLogin(username user: String) -> User? {
        UserDefaults.standard.set(user, forKey: Keys.usernameKey)
        self.currentUser = self.loadUser(from: user)
        return self.currentUser
    }
    
    @discardableResult
    func registerUser(username user: String) -> Bool {
        if let _ = loadUser(from: user) {return false}
        let newUser = User()
        newUser.username = user
        User.resetDogHousesToDefault(onUser: newUser)
        self.context.save(newUser)
        return true
    }

    func loadUser(from username: String) -> User? {
        return self.context.fetch(User.self, {$0.username == username}).first
    }
}
