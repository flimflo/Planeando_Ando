//
//  Event.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores on 21/11/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}


struct Event {
    var title:String
    var description:String
    var startTime:Date
    var place:String
    var status:String
    var joinId:String
    var members:Array<String>
    
    var dictionary:[String:Any] {
        return [
            "title":title,
            "description":description,
            "startTime":startTime,
            "place":place,
            "status":status,
            "joinId":joinId,
            "members":members
        ]
    }
}

extension Event {
    
    init(){
        title = ""
        description = ""
        startTime = Date()
        place = ""
        status = ""
        joinId = ""
        members = [String]()
    }
}

extension Event : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let title = dictionary["tile"] as? String,
            let description = dictionary["description"] as? String,
            let startTime = dictionary ["startTime"] as? Date,
            let place = dictionary["place"] as? String,
            let status = dictionary["status"] as? String,
            let joinId = dictionary["joinId"] as? String,
            let members = dictionary["members"] as? Array<String> else {return nil}
        
        self.init(title: title, description: description, startTime: startTime, place: place, status: status, joinId: joinId, members: members)
    }
}



