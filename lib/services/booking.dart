
import "package:range/range.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class BookingItem{
  String user;
  final int hourEnd;
  final int hourStart;
  final int minuteStart;
  final int minuteEnd;
  final int sortId;
  final String id;

  BookingItem({this.user,this.hourStart,this.minuteStart,this.hourEnd,this.minuteEnd,this.sortId,this.id});

}

class BookingTable{
  static List<BookingItem> getDefaultDayTable(){
    List<BookingItem> list = new List();

    range(8,21).toList().forEach((h){
      range(0,60,10).toList().forEach((m){
        int minuteEnd =m!=50?m+10:59;
        list.add(new BookingItem(hourStart: h,minuteStart: m,hourEnd: h,minuteEnd: minuteEnd,sortId: int.parse(h.toString()+minuteEnd.toString())));
      });
    });

    return list;
  }
}

class BookingModel{
  Future<List<BookingItem>> getTable(String activityId) async{
  QuerySnapshot snapshot = await Firestore.instance.collection('offices/vinnytsa/activities').document(activityId).getCollection("book_periods").getDocuments();
  return snapshot.documents.map((document){

      return new BookingItem(user: document["email"],
          hourStart: document["hour_start"],
          hourEnd: document["hour_end"],
          minuteStart: document["minute_start"],
          minuteEnd: document["minute_end"],
          sortId: document ["sort_id"],
          id: document.documentID
      );
    }).toList();
  }
}
