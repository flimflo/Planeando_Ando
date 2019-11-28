//
//  Junta.swift
//  Planeando_Ando
//
//  Created by Fernando Limón Flores and Mildred Gil
//
//  Copyright © 2019 Fernando Limón Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializablejun  {
    init?(dictionary:[String:Any])
}

struct Junta {
    var description:String
    var start:Date
    var end:Date
    var id:String
    
    var dictionary:[String:Any] {
        return [
            "description":description,
            "start":Timestamp(date: start),
            "end":Timestamp(date: end),
            "id":id
        ]
    }
}

extension Junta {
    
    init(){
        description = ""
        start = Date()
        end = Date()
        id = ""
    }
}

extension Junta : DocumentSerializablejun {
    init?(dictionary: [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let description = dictionary["description"] as? String,
            let startTime = dictionary ["start"] as? Date,
            let endTime = dictionary["end"] as? Date else {return nil}
        
        self.init(description:description,start:startTime,end:endTime,id:id)
    }
}
