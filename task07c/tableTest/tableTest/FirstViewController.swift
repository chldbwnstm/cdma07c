//
//  FirstViewController.swift
//  tableTest
//
//  Created by Yoojoon Choi on 11/4/19.
//  Copyright © 2019 Himanshu Nag. All rights reserved.
//

import Foundation
import UIKit

class FirstViewController: UITableViewController {
    struct Actor: Codable {
        let firstname: String
        let lastname: String
        let yearofbirth: Int
    }
    
    struct Actors: Codable {
        let Actors: [Actor]
    }

    let actorCell = "actorcell"
    
    var actors: Actors? = nil
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
             //Register the table view cell class and its reuse id
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: actorCell)

            tableView.delegate = self
            tableView.dataSource = self

            guard let path = Bundle.main.path(forResource: "actors", ofType: "json") else {return}
        let url = URL(fileURLWithPath: path)

        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }

            //decodes json and assign values to each appropriate actor
            do {
                let decoder = JSONDecoder()
                let actors = try decoder.decode(Actors.self, from: data)
                self.actors = actors

            } catch let err {
                print("Err", err)
            }
            }.resume()

            DispatchQueue.main.async {
                self.tableView.reloadData()
                }
        
        }
    
        //number of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors?.Actors.count ?? 0
        }
    
        // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: actorCell) as? UITableViewCell)!
        
            // set the text from the data model
        cell.textLabel?.text = actors!.Actors[indexPath.row].firstname + " " + actors!.Actors[indexPath.row].lastname + ", YOB: " + String(actors!.Actors[indexPath.row].yearofbirth)
        
            return cell
        }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
return true
}
}
