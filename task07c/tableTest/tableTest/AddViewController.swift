//
//  AddViewController.swift
//  tableTest
//
//  Created by Yoojoon Choi on 26/5/19.
//  Copyright © 2019 Himanshu Nag. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var yearOfBirth: UITextField!
    @IBOutlet weak var addActor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "backToMain", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let firstController = segue.destination as! ViewController
        firstController.firstNameFromAddPage = firstName.text
        firstController.lastNameFromAddPage = lastName.text
        firstController.yearOfBirthFromAddPage = Int(yearOfBirth.text!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
