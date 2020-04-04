import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:senam/blocs/bloc.dart';
import 'package:senam/screens/more/commision.dart';
const String apiUrl="https://snam.sa/api/v1";
class StaticData {
  String about;
  String whatsapp;
  String contact;
  String percent;
  String email;
  String instagram;
  String twitter;
  int percent_ratio;
  StaticData(
      {this.about,
      this.email,
      this.contact,
      this.percent,
      this.instagram,
      this.whatsapp,
      this.percent_ratio,
      this.twitter,
     });
  factory StaticData.fromJson(Map<String, dynamic> setting) {
    if (setting['status'] == 200)
      return StaticData(
          about: setting['data']['about'],
          email: setting['data']['email'],
          whatsapp: setting['data']['mobile'],
          percent: setting['data']['percent'],
          contact: setting['data']['contact'],

          twitter: setting['data']['twitter'],
          percent_ratio: setting['data']['percent_ratio'],
          instagram: setting['data']['instagram']);
    else
      return StaticData(
          about: "", email: "",  whatsapp: "", twitter: "", instagram: "",);
  }
}

Future staticData() async {
  http.Response response =
      await http.get("$apiUrl/setting");
  final staticData = json.decode(response.body);
  StaticData data=  StaticData.fromJson(staticData);
  bloc.sendStaticData(data);
}
class Bank{
  int id;
      String company_name;
          String name;
         String   account_number;
       String logo;
       Bank({this.id,this.name,this.account_number,this.company_name,this.logo});
      factory Bank.fromJson(Map<String,dynamic>bank){
        return Bank(id: bank['id'],
        account_number: bank['account_number'],
        company_name: bank['company_name'],
        logo: bank['logo'],
        name: bank['name']
        );
      }  
}
Future getBanksData() async {
  http.Response response =
      await http.get("$apiUrl/bank");
  final banksData = json.decode(response.body);
  List<Widget>banks=[];
  if(banksData['status']==200){
    for(int i=0;i<banksData['data'].length;i++){
     Bank bank = Bank.fromJson(banksData['data'][i]);
     banks.add(BankCard(
       bankImage: bank.logo,
       bankName: bank.name,
       bankNumber: bank.account_number,
     ));

    }
  }
  return banks;
}

  getContactTyps()async{
     http.Response response =
      await http.get("$apiUrl/reason",
      headers: bloc.currentUser()!=null?{"apiToken":"sa3d01${bloc.currentUser().apiToken}"}:null);
  final reasonsData = json.decode(response.body);
  Map<int,String>reasons={};
  if(reasonsData['status']==200){
for(int i=0;i<reasonsData['data'].length;i++)
{
  reasons[reasonsData['data'][i]['id']]=reasonsData['data'][i]['name'];
}
  }
  bloc.addNewcontactTyps(reasons);
return reasons;

  }

  contactUs(int id,String reason)async{
     http.Response response =
      await http.post("$apiUrl/contact",
      body: {"reason_id":id.toString(),"message":reason},
      headers:bloc.currentUser()!=null?{"apiToken":"sa3d01${bloc.currentUser().apiToken}"}:null);
  final reasonsData = json.decode(response.body);
  if (reasonsData['status'] == 200) {
    return "تم الإرسال";
  } else if (reasonsData['status'] == 401)
    return 401;
  else
    return reasonsData['msg'];

  }
