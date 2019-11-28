//
//  JuntasTableViewController.swift
//  Planeando_Ando
//
//  Created by Angel Figueroa Rivera on 11/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class JuntasTableViewController: UITableViewController {

    @IBOutlet var popOver: UIView!
    @IBOutlet weak var tfNewDesc: UITextField!
    @IBOutlet weak var pckNewDateTimeStart: UIDatePicker!
    @IBOutlet weak var pckNewDateTimeEnd: UIDatePicker!
    
    var tap : UITapGestureRecognizer!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var Evento:Event = Event()
    
    var juntasArray = [Junta]()
    
    var user = Auth.auth().currentUser?.email
    
    var db:Firestore!
    
    //let settings = db.settings
    //settings.are
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopOver))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        db = Firestore.firestore()
        
        checkForAdd()
    }
    
    func checkForAdd() {
        db.collection("events").document(Evento.docRef).collection("meetings").order(by: "start", descending: true).addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach {
                    diff in
                    
                    if diff.type == .added {
                        
                        let datos = diff.document.data()
                        let description = datos["description"] as? String ?? ""
                        
                        let tsStart = datos["start"] as! Timestamp
                        let startTime = tsStart.dateValue()
                        
                        let tsEnd = datos["end"] as! Timestamp
                        let endTime = tsEnd.dateValue()
                        //let formatter = DateFormatter()
                        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                        //let formattedTimeZoneStr = formatter.string(from: aDate)
                        
                        let id = datos["id"] as? String ?? ""
                        
                        let junta = Junta(description: description, start: startTime, end: endTime,id: id)
                        print(junta)
                        print("\n")
                        print("\n")
                        print("\n")
                        print(datos)
                        self.juntasArray.append(junta)
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
        return juntasArray.count
    }
    
    @IBAction func AgregarJunta(_ sender: UIBarButtonItem) {
        self.view.addSubview(popOver)
        view.addGestureRecognizer(tap)
        popOver.frame = CGRect(x: screenWidth / 2 - 150, y: 0, width: 300, height: 450)
    }
    
    @IBAction func dismissPopOver() {
        view.endEditing(true)
        self.popOver.removeFromSuperview()
        view.removeGestureRecognizer(tap)
    }
    
    @IBAction func onAddNew(_ sender: Any) {
        if let desc = tfNewDesc.text {
            let startTime  = obtenerFecha(date : pckNewDateTimeStart)
                
            let endTime  = obtenerFecha(date : pckNewDateTimeEnd)

            let junta = Junta(description: desc, start: startTime, end: endTime,id: "")
            
            var ref:DocumentReference? = nil
            ref = db.collection("events").document(Evento.docRef).collection("meetings").addDocument(data: junta.dictionary) {
                error in
                
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                }else{
                    print("Document added with ID: \(ref!.documentID)")
                    self.db.collection("events").document(self.Evento.docRef).collection("meetings").document(String(ref!.documentID)).setData([ "id": String(ref!.documentID)], merge: true)
                }
            }
            
            //juntasArray.append(junta)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            dismissPopOver()
        }
    }
    
    func obtenerFecha(date : UIDatePicker) -> Date{
        return date.date
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        let junta = juntasArray[indexPath.row]
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        cell.textLabel?.text = "\(junta.description)"
        cell.detailTextLabel?.text = formatter.string(from: junta.start) + " - " + formatter.string(from: junta.end)

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
            if Evento.members[0] == user {
                
                db.collection("events").document(Evento.docRef).collection("meetings").whereField("id", isEqualTo: juntasArray[indexPath.row].id)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let document = querySnapshot!.documents.first
                            document?.reference.delete()
                            
                            self.juntasArray.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
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

}
