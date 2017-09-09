//
//  CreateNewOwnerViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 13/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CreateNewOwnerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let owner = StorageContext().fetch(Owner.self)
        print(owner.map({$0.jsonString}))
        
        if let own = owner.first {            
            own.name! += "Jorge"
            own.email! += "mr.jorge.xavier"
            StorageContext().save(own)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let owner = StorageContext().fetch(Owner.self)
        print(owner.map({$0.jsonString}))
        
        let ow1ner = Owner()
        ow1ner.name = "Jorge"
        ow1ner.email = "mr.jorge.xavier"
        StorageContext().save(ow1ner)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let owner = StorageContext().fetch(Owner.self)
        print(owner.map({$0.jsonString}))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
