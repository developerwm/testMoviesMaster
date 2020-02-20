
import Foundation
import ObjectMapper
import RealmSwift

class MovieDB: Object, Mappable {

@objc dynamic var id = ""
@objc dynamic var name = ""
@objc dynamic var average = ""
@objc dynamic var total = ""
@objc dynamic var image = ""
@objc dynamic var favorite = false

required convenience init?(map: Map) {
    self.init()
}

override class func primaryKey() -> String? {
    return "id"
}

func mapping(map: Map) {
    name<-map["name"]
    average<-map["average"]
    total<-map["total"]
    image<-map["image"]
    favorite<-map["favorite"]
}
    
}
