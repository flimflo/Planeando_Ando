//
//  Junta.swift
//  Planeando_Ando
//
//  Created by Angel Figueroa Rivera on 11/27/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Junta {
    var description:String
    var start:Date
    var end:Date
    
    var dictionary:[String:Any] {
        return [
            "description":description,
            "start":start,
            "end":end
        ]
    }
}

extension Junta {
    
    init(){
        description = ""
        start = Date()
        end = Date()
    }
}
