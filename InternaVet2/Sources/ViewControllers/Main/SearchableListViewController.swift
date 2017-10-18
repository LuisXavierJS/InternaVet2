//
//  SearchableListViewController.swift
//  InternaVet2
//
//  Created by Jorge Luis on 08/09/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class MockCell {
    var height: CGFloat = 50
    var isShowing: Bool = false {
        didSet{
            if self.isShowing {
                self.height = 135
            }else {
                self.height = 50
            }
        }
    }
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
}

class MockTableViewCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: ValuedUILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    func setLabels(_ mock: MockCell) {
        self.label1.text = mock.title
        self.label2.text = mock.title
        self.label3.text = mock.title
        self.label4.text = mock.title
    }
}

class SearchableListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var listTableView: UITableView! {
        didSet{
            self.listTableView.delegate = self
            self.listTableView.dataSource = self
        }
    }
    
    let datasource: [MockCell] = [MockCell("cell 1"),MockCell("cell 2"),MockCell("cell 3"),
                                  MockCell("cell 4"),MockCell("cell 5"),MockCell("")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MockCell", for: indexPath) as! MockTableViewCell
        cell.setLabels(self.datasource[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.datasource[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.datasource[indexPath.row].isShowing = !self.datasource[indexPath.row].isShowing
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
