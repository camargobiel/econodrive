import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectCity extends StatefulWidget {
  final Function(String) onCitySelected;

  const SelectCity({
    super.key,
    required this.onCitySelected,
  });

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  late Future<Map<String, dynamic>> _futureCities;
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>> fetchCities(String search) async {
    final where = Uri.encodeQueryComponent(jsonEncode({
      "name": {"\$regex": search, "\$options": "i"}
    }));
    final response = await http.get(
      Uri.parse(
        "https://parseapi.back4app.com/classes/Estadoscidadesbrasil_City?limit=10&excludeKeys=country&where=$where",
      ),
      headers: {
        "X-Parse-Application-Id": "dsmGJGwuNkuL5749kW1w92f85HnpGnbDUSzXGTir",
        "X-Parse-REST-API-Key": "5GM1s2uRZ3BDAYmnlrUGWBtXbirngxmxGp8R53tw"
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    _futureCities = fetchCities("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Pesquise por uma cidade',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _futureCities = fetchCities(value);
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: _futureCities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final cities = snapshot.data as Map<String, dynamic>;
                return ListView.builder(
                  itemCount: cities['results'].length,
                  itemBuilder: (context, index) {
                    final city = cities['results'][index];
                    return ListTile(
                      title: Text(city['name']),
                      onTap: () {
                        widget.onCitySelected(city['name']);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
