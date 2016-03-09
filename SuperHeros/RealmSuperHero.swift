//
//  RealmSuperHero.swift
//  SuperHeros
//
//  Created by Juan Pablo Villa on 3/4/16.
//  Copyright © 2016 Segundamano.mx. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSuperHero : Object {
    dynamic var name : String = ""
    dynamic var realName : String = ""
    dynamic var image : String = ""
}
