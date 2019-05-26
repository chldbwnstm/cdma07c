import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    struct Actor: Codable {
        let firstname: String
        let lastname: String
        let yearofbirth: Int
    }
    
    struct Actors: Codable {
        var Actors: [Actor]
    }
    
    let actorCell = "actorcell"
    
    var actors: Actors? = nil
    
    var selectedSegment = 0
    
    var firstNameFromAddPage:String? = nil
    var lastNameFromAddPage:String? = nil
    var yearOfBirthFromAddPage:Int? = nil
    
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 0
        } else if sender.selectedSegmentIndex == 1 {
            selectedSegment = 1
        } else {
            selectedSegment = 2
        }
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: actorCell)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //check if file is available, use guard to protect file not available case
        guard let path = Bundle.main.path(forResource: "actors", ofType: "json") else {print("FILE IS NOT AVAILABLE"); return}
        print("FILE IS AVAILABLE")
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
            self.addActorIfAny(firstName: self.firstNameFromAddPage, lastName: self.lastNameFromAddPage, yearOfBirth: self.yearOfBirthFromAddPage)
        }
        
        
        
        
    }
    
    func addActorIfAny(firstName: String!,lastName: String!, yearOfBirth: Int!) -> Void {
        if firstName != nil {
            var newActor = Actor(firstname: firstName, lastname: lastName, yearofbirth: yearOfBirth)
                actors!.Actors.append(newActor)
        }
    }
    
    //number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(selectedSegment == 2) {
            var newActors = actors!.Actors.filter{(2019-$0.yearofbirth) < 30}
            return newActors.count ?? 0
            
        } else {
            return actors?.Actors.count ?? 0
        }
        
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: actorCell) as? UITableViewCell)!
        
        // set the text from the data model
        if selectedSegment == 0 {
            actors?.Actors.sort() {$0.firstname < $1.firstname}
        } else if selectedSegment == 1{
            actors?.Actors.sort() {$0.yearofbirth > $1.yearofbirth}
        } else {
            var newActors = actors!.Actors.filter{(2019-$0.yearofbirth) < 30}
            
            cell.textLabel?.text = newActors[indexPath.row].firstname + " " + newActors[indexPath.row].lastname + ", YOB: " + String(newActors[indexPath.row].yearofbirth)
            
            return cell
        }
        
        
        cell.textLabel?.text = actors!.Actors[indexPath.row].firstname + " " + actors!.Actors[indexPath.row].lastname + ", YOB: " + String(actors!.Actors[indexPath.row].yearofbirth)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle==UITableViewCell.EditingStyle.delete{
            actors!.Actors.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    //deleteAction
    
    @IBAction func deleteItem(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
    }
    
    
    @IBAction func addActor(_ sender: Any) {
        performSegue(withIdentifier: "addActor", sender: self)
    }
    
    
}


