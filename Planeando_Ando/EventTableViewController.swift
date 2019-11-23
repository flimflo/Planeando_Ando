//
//  EventTableViewController.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores on 10/11/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventTableViewController: UITableViewController {
    
    var db:Firestore!
    
    var eventArray = [Event]()
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        db = Firestore.firestore()
        //loadData()
        checkForUpdates()
        
    }
    
    @IBOutlet var popOver: UIView!
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        self.view.addSubview(popOver)

        popOver.frame = CGRect(x: self.view.frame.width - 127, y: 0, width: 127, height: 127)
    }
    
    @IBAction func dismissPopOver(_ sender: Any) {
        self.popOver.removeFromSuperview()
    }
    
    func loadData() {
        db.collection("events").whereField("members", arrayContains: "flimflo2@hotmail.com").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let datos = document.data()
                    let title = datos["title"] as? String ?? ""
                    let description = datos["description"] as? String ?? ""
                    let place = datos["place"] as? String ?? ""
                    let status = datos["status"] as? String ?? ""
                    let joinId = datos["joinId"] as? String ?? ""
                    let startTime = datos["startTime"] as? Date ?? Date()
                    let members = datos["members"] as? Array<String> ?? [String]()
                    
                    let evento = Event(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members)
                    
                    self.eventArray.append(evento)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.checkForUpdates()
            }
        }
    }
    
    
    func checkForUpdates() {
        db.collection("events").order(by: "startTime", descending: true).whereField("members", arrayContains: "flimflo2@hotmail.com").whereField("startTime", isGreaterThan: Date()).addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach {
                    diff in
                    
                    if diff.type == .added {
                        let datos = diff.document.data()
                        let title = datos["title"] as? String ?? ""
                        let description = datos["description"] as? String ?? ""
                        let place = datos["place"] as? String ?? ""
                        let status = datos["status"] as? String ?? ""
                        let joinId = datos["joinId"] as? String ?? ""
                        let startTime = datos["startTime"] as? Date ?? Date()
                        let members = datos["members"] as? Array<String> ?? [String]()
                        
                        let evento = Event(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members)
                        
                        self.eventArray.append(evento)
                        self.count = self.count + 1
                        print(self.count)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let event = eventArray[indexPath.row]
        
        cell.textLabel?.text = "\(event.title)"
        //cell.detailTextLabel?.text = "\(sweet.timeStamp)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "goToTab", sender: self)
           print("row seleccionada: \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToTab"){
               
            let vistaNueva = segue.destination as! Class_TabBar
               
            let indexPath = tableView.indexPathForSelectedRow!
               
            vistaNueva.jug = eventArray[indexPath.row].title
        }
        else{
               /*let vistaAgrega = segue.destination as! ViewControllerAgregar
               vistaAgrega.delegado = self*/
        }
    }
}

