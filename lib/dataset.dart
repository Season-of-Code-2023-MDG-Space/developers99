import 'package:flutter/material.dart';

num balance1 = 200000;
num balance2 = 20000;

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
      balance: balance1.toString(),
      date: '12/26',
      number:'5262',
      color: Colors.blue,
      image: "assets/mastercard.png"
  ),
  CardData(
      balance: balance2.toString(),
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