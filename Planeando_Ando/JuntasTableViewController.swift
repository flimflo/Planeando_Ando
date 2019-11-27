//
//  JuntasTableViewController.swift
//  Planeando_Ando
//
//  Created by Angel Figueroa Rivera on 11/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class JuntasTableViewController: UITableViewController {

    @IBOutlet var popOver: UIView!
    @IBOutlet weak var tfNewDesc: UITextField!
    @IBOutlet weak var pckNewDateTimeStart: UIDatePicker!
    @IBOutlet weak var pckNewDateTimeEnd: UIDatePicker!
    
    var tap : UITapGestureRecognizer!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var juntasArray = [Junta]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissPopOver))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

            let junta = Junta(description: desc, start: startTime, end: endTime)
            juntasArray.append(junta)
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
        
        formatter.dateFormat = "MM-dd-yy HH:mm"
        formatter.string(from: junta.start)
        formatter.string(from: junta.start)
        
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
            juntasArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
