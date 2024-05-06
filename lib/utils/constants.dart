import 'package:flutter/material.dart';

List<DropdownMenuItem<Object>>? vehicleTypes = [
  const DropdownMenuItem(
    value: "truck",
    child: Text('Caminhonete'),
  ),
  const DropdownMenuItem(
    value: 'sedan',
    child: Text('Sedan'),
  ),
  const DropdownMenuItem(
    value: "hatch",
    child: Text('Hatch'),
  ),
];
