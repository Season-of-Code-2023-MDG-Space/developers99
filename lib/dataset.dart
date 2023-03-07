import 'package:flutter/material.dart';

class CardData{
  final String balance;
  final String date;
  final String number;
  final Color color;
  final String image;

  CardData({required this.balance, required this.date, required this.number, required this.color,required this.image});
}

List<CardData> cards = [
  CardData(
      balance: '23,532',
      date: '12/26',
      number:'5262',
      color: Colors.blue,
      image: "assets/mastercard.png"
  ),
  CardData(
      balance: '48,632',
      date: '01/23',
      number:'5737',
      color: Colors.red,
      image: "assets/mastercard.png"

  ),
  CardData(
      balance: '74,363',
      date: '07/24',
      number:'6315',
      color: Colors.green,
      image: "assets/mastercard.png"

  )
];