

class Data {
  int id;
  String subject;
  int totalClasses;
  int attended;
  Data({this.id,this.subject,this.totalClasses,this.attended});

  Map<String , dynamic> toMap (){
    return{
      "id":id,
      "subject":subject,
      "TotalClasses": totalClasses,
      "attended":attended
    };
  }

}