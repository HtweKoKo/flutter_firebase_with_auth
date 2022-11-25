

class Person{

  String? name,address;
  String ? age;
  // int? timeStamp;
  Person({ this.name, this.age, this.address,this.imageUrl});
  String? imageUrl;
  
  factory Person.fromMap(Map map){
    return Person(
      name: map["name"], 
      age: map["age"], 
      // timeStamp: map["timeStamp"],
      imageUrl: map["imageUrl"],
      address: map["address"]);
  }
  Map<String,dynamic> toMap(){
    return {
        "name":name,
        "age":age,
        "address" : address,
        // "timeStamp" : timeStamp,
        "imageUrl" : imageUrl


    };
  }
}