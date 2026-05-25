/*
DraggableScrollableSheet(
initialChildSize: 0.25,
minChildSize: 0.15,
maxChildSize: 0.8,
builder: (context, scrollController) {
return Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
boxShadow: [
BoxShadow(
color: Colors.black26,
blurRadius: 10,
spreadRadius: 5,
),
],
),
child: ListView(*/
/**//*

controller: scrollController,
children: [
Center(
child: Container(
width: 50,
height: 5,
margin: EdgeInsets.symmetric(vertical: 12),
decoration: BoxDecoration(
color: Colors.grey[400],
borderRadius: BorderRadius.circular(10),
),
),
),

Padding(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"Ride Information",
style: TextStyle(
fontSize: 22, fontWeight: FontWeight.bold),
),
SizedBox(height: 10),
Text(
"This bottom sheet is draggable!\nSwipe up to expand, swipe down to collapse.",
style: TextStyle(fontSize: 16),
),
SizedBox(height: 20),

ListTile(
leading: Icon(Icons.local_taxi, color: Colors.black),
title: Text("Driver: John Doe"),
subtitle: Text("Car: White Swift Dzire\nUP-70-1234"),
trailing: Icon(Icons.phone, color: Colors.green),
),
Divider(),
ListTile(
leading:
Icon(Icons.location_on, color: Colors.redAccent),
title: Text("Pickup Location"),
subtitle: Text("Ambedkar Nagar, UP"),
),
ListTile(
leading: Icon(Icons.flag, color: Colors.blueAccent),
title: Text("Drop Location"),
subtitle: Text("Lucknow, UP"),
),
SizedBox(height: 30),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.black,
foregroundColor: Colors.white,
minimumSize: Size(double.infinity, 50),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
onPressed: () {},
child: Text("Confirm Ride"),
),
SizedBox(height: 50),
],
),
),
],
),
);
},
),*/
