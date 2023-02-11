//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Anton Tyurin on 10.02.2023.
//

import RealmSwift

// model' dannyh
class Place: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?

    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}

//    let restaurantNames = ["Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
//                                  "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
//                                  "Speak Easy", "Morris Pub", "Вкусные истории",
//                                  "Классик", "Love&Life", "Шок", "Бочка"]
