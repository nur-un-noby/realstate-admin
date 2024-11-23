import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          height: 40.0,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search properties...',
                    prefixIcon: Icon(
                      FontAwesomeIcons.magnifyingGlass, // Bootstrap-styled search icon
                      color: Colors.blueAccent, // Icon color
                      size: 20.0, // Icon size for better visibility
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  _showFiltersDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(8.0),
                  elevation: 2.0,
                ),
                child: Icon(
                  FontAwesomeIcons.filter, // Filter icon
                  size: 18.0,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                _buildFilterChip(FontAwesomeIcons.sliders, 'Filters'),
                _buildFilterChip(FontAwesomeIcons.tags, 'Price'),
                _buildFilterChip(FontAwesomeIcons.bed, 'Bedrooms'),
              ],
            ),
          ),
          // Property Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 10, // Replace with property data count
              itemBuilder: (context, index) {
                return _buildPropertyCard();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plusCircle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userCircle),
            label: 'Account',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/create');
              break;
            case 2:
              Navigator.pushNamed(context, '/saved');
              break;
            case 3:
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
      ),
    );
  }

  Widget _buildFilterChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[50],
          foregroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: FaIcon(icon, size: 16),
        label: Text(label, style: TextStyle(fontSize: 14)),
        onPressed: () {
          // Handle filter logic
        },
      ),
    );
  }

  Widget _buildPropertyCard() {
    return Card(
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.0,
            color: Colors.grey[300], // Placeholder for property image
            child: Center(child: Text('400 × 320')),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Modern Apartment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  'Dhaka, Bangladesh',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4.0),
                Text(
                  'BDT 25,000/mo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Price Range (BDT)', style: TextStyle(fontWeight: FontWeight.bold)),
              RangeSlider(
                values: RangeValues(5000, 50000),
                min: 1000,
                max: 100000,
                divisions: 20,
                onChanged: (values) {
                  // Handle price range changes
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Minimum Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Maximum Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        );
      },
    );
  }
}
