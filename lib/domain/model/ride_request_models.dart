class RideRequestModel {
  final String id ;
  final String imageUrl ;
  final String rideTag;
  final DateTime createdAt;
RideRequestModel({required this.id, required this.imageUrl, required this.rideTag,required this.createdAt});



  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(id:json['id'] , imageUrl:json ['rideInfoMsgUrl'],rideTag: json['rideTag'], createdAt: DateTime.parse(json['createdAt']));
  }



}