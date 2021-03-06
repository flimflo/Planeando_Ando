//
//  EventTableViewController.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class EventTableViewController: UITableViewController {
    
    var db:Firestore!
    
    var user = Auth.auth().currentUser?.email
    
    var eventArray = [Event]()
    
    var modifyIndex:String = ""
    
    var tap : UITapGestureRecognizer!
    
    @IBOutlet var popOver: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopOver))
        
        db = Firestore.firestore()

        checkForUpdates()
        checkForAdd()
        checkForDelete()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        self.view.addSubview(popOver)
        view.addGestureRecognizer(tap)
        popOver.frame = CGRect(x: self.view.frame.width - 190, y: 0, width: 190, height: 127)
    }
    
    @IBAction func Cerrar_sesion(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error al salir de la aplicación")
        }
    }
    
    @IBAction func dismissPopOver() {
        view.endEditing(true)
        self.popOver.removeFromSuperview()
        view.removeGestureRecognizer(tap)
    }
    
    func checkForAdd() {
        db.collection("events").order(by: "startTime", descending: true).whereField("members", arrayContains: user).addSnapshotListener {
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
                        
                        let tsStart = datos["startTime"] as! Timestamp
                        let startTime = tsStart.dateValue()
                        
                        let members = datos["members"] as? Array<String> ?? [String]()
                        let docRef = datos["docRef"] as? String ?? ""
                        
                        let evento = Event(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members, docRef: docRef)
                        
                        self.eventArray.append(evento)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func checkForUpdates() {
        db.collection("events").order(by: "startTime", descending: true).whereField("members", arrayContains: user).addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach {
                    diff in
                    
                    if diff.type == .modified {
                        
                        let datos = diff.document.data()
                        let title = datos["title"] as? String ?? ""
                        let description = datos["description"] as? String ?? ""
                        let place = datos["place"] as? String ?? ""
                        let status = datos["status"] as? String ?? ""
                        let joinId = datos["joinId"] as? String ?? ""
                        
                        let tsStart = datos["startTime"] as! Timestamp
                        let startTime = tsStart.dateValue()
                        
                        let members = datos["members"] as? Array<String> ?? [String]()
                        let docRef = datos["docRef"] as? String ?? ""
                        
                        let evento = Event(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members, docRef: docRef)
                        
                        var index = 0
                        for i in 0..<self.eventArray.count {
                            
                            if self.eventArray[i].joinId == evento.joinId {
                                index = i
                            }
                        }
                        self.eventArray.remove(at: index)
                        self.eventArray.insert(evento, at: index)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
    func checkForDelete() {
        db.collection("events").order(by: "startTime", descending: true).whereField("members", arrayContains: user).addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach {
                    diff in
                    
                    if diff.type == .removed {
                        print("Removed user: \(diff.document.data())")
                        let datos = diff.document.data()
                        let title = datos["title"] as? String ?? ""
                        let description = datos["description"] as? String ?? ""
                        let place = datos["place"] as? String ?? ""
                        let status = datos["status"] as? String ?? ""
                        let joinId = datos["joinId"] as? String ?? ""
                        let startTime = datos["startTime"] as? Date ?? Date()
                        let members = datos["members"] as? Array<String> ?? [String]()
                        let docRef = datos["docRef"] as? String ?? ""
                        
                        let evento = Event(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members,docRef: docRef)
                        
                        var index = 0
                        for i in 0..<self.eventArray.count {
                            
                            if self.eventArray[i].joinId == evento.joinId {
                                index = i
                            }
                        }
                        self.eventArray.remove(at: index)
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            if eventArray[indexPath.row].members[0] == user {
                
                db.collection("events").whereField("joinId", isEqualTo: eventArray[indexPath.row].joinId)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let document = querySnapshot!.documents.first
                            document?.reference.delete()
                        }
                }
            }else{
                
                db.collection("events").whereField("joinId", isEqualTo: eventArray[indexPath.row].joinId)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let document = querySnapshot!.documents.first
                            document?.reference.updateData([
                                "members": FieldValue.arrayRemove([self.user])
                            ])
                        }
                }
            }
        }
    }

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

    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           //performSegue(withIdentifier: "goToTab", sender: self)
           print("row seleccionada: \(indexPath.row)")
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToTab"){
            
            let tabVc = segue.destination as! Class_TabBar
            
            let infVc = tabVc.viewControllers?.first as! Informacion_ViewController
               
            let indexPath = tableView.indexPathForSelectedRow!
            
            infVc.Evento = eventArray[indexPath.row]
            
            let navVc = tabVc.viewControllers![1] as! UINavigationController
            let juntaVc = navVc.viewControllers.first as! JuntasTableViewController
            
            juntaVc.Evento = eventArray[indexPath.row]
            
            let chatView = tabVc.viewControllers?[2] as! ChatViewController
            
            chatView.Evento = eventArray[indexPath.row]
        }
    }
}

