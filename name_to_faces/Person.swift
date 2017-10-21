//
//  Person.swift
//  name_to_faces
//
//  Created by Erin Moon on 10/20/17.
//  Copyright © 2017 Erin Moon. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
