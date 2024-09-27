import 'package:accomodation_app/screens/bottom_nav_bar.dart';
import 'package:accomodation_app/screens/new_home.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<int, bool> expansionState = {};
  TextEditingController searchController = TextEditingController();
  List<Employee> filteredEmployees = employees;

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees.where((employee) {
          return employee.name.toLowerCase().contains(query.toLowerCase()) ||
              employee.designation.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // leading: Navigator.pop(),
        // leading: IconButton(
        //   // Within the `FirstRoute` widget:
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => BottomNavBar()),
        //     );
        //   },
        //     icon:  Icon(Icons.arrow_back_ios,size: 23,)),
        // centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                _filterEmployees(value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search by name or designation',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    searchController.clear();
                    _filterEmployees('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.deepOrangeAccent,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                final isExpanded = expansionState[index] ?? false;
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.grey.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Row(
                        children: [
                          CircleAvatar(
                            // backgroundColor: Colors.black45,
                            backgroundColor: Colors.orangeAccent,
                            radius: 20,
                            child: Text(
                              employee.name[0],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                employee.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                employee.designation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: isExpanded
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(5.0),
                          backgroundColor: Colors.deepOrangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Handle button press
                        },
                        child: const Text(
                          "Generate Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )
                          : const Icon(Icons.expand_more, color: Colors.grey),
                      onExpansionChanged: (isExpanded) {
                        setState(() {
                          expansionState[index] = isExpanded;
                        });
                      },
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight:
                                employee.events.length <= 4 ? 100 : 200,
                                maxHeight: employee.events.length > 4
                                    ? 250
                                    : double.infinity,
                              ),
                              child: SingleChildScrollView(
                                child: FixedTimeline(
                                  theme: TimelineThemeData(
                                    nodePosition: 0.1,
                                    color: Colors.grey,
                                    connectorTheme: ConnectorThemeData(
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  children: List.generate(
                                      employee.events.length, (eventIndex) {
                                    final event = employee.events[eventIndex];
                                    return TimelineTile(
                                      nodeAlign: TimelineNodeAlign.start,
                                      contents: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(event.startDate,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                const SizedBox(width: 10),
                                                const Text("to",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54)),
                                                const SizedBox(width: 10),
                                                Text(event.endDate,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 2),
                                              decoration: BoxDecoration(
                                                // color: Colors.orangeAccent.withOpacity(0.1),
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.black12)),
                                              child: Text(
                                                event.city,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      node: TimelineNode(
                                        indicator: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            DotIndicator(
                                              color: event.isCompleted
                                                  ? Colors.grey
                                                  : Colors.deepOrangeAccent,
                                              size: 16,
                                            ),
                                            if (event.isCompleted)
                                              const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                          ],
                                        ),
                                        endConnector: eventIndex !=
                                            employee.events.length + 1
                                            ? const SolidLineConnector()
                                            : null,
                                        startConnector: eventIndex != 0
                                            ? const SolidLineConnector()
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Employee {
  final String name;
  final String designation;
  final List<RouteEvent> events;

  Employee({
    required this.name,
    required this.designation,
    required this.events,
  });
}

class RouteEvent {
  final String startDate;
  final String endDate;
  final String city;
  final bool isCompleted;

  RouteEvent({
    required this.startDate,
    required this.endDate,
    required this.city,
    this.isCompleted = false,
  });
}

final employees = [
  Employee(
    name: 'John Doe',
    designation: 'Delivery Manager',
    events: [
      RouteEvent(
          startDate: "11-22-2024",
          city: "Alexandria, VA",
          isCompleted: false,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Alexandria, VA",
          isCompleted: true,
          endDate: '11-22-2024'),
    ],
  ),
  Employee(
    name: 'Ajgf Smith',
    designation: 'Field Coordinator',
    events: [
      RouteEvent(
          startDate: "11-22-2024",
          city: "Philadelphia, PA",
          isCompleted: false,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Philadelphia, PA",
          isCompleted: true,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Philadelphia, PA",
          isCompleted: true,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Philadelphia, PA",
          isCompleted: true,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Philadelphia, PA",
          isCompleted: true,
          endDate: '11-22-2024'),
      RouteEvent(
          startDate: "11-22-2024",
          city: "Hackensack, NJ",
          isCompleted: true,
          endDate: '11-22-2024'),
    ],
  ),
  Employee(
    name: 'Mark Johnson',
    designation: 'Logistics Supervisor',
    events: [
      RouteEvent(
          startDate: "11/22/2024",
          city: "South Hackensack, NJ",
          isCompleted: false,
          endDate: '11/22/2024'),
    ],
  ),
  Employee(
    name: 'Krup Lfhdk',
    designation: 'Logistics Supervisor',
    events: [
      RouteEvent(
          startDate: "11/22/2024",
          city: "South Hackensack, NJ",
          isCompleted: false,
          endDate: '11/22/2024'),
      RouteEvent(
          startDate: "11/22/2024",
          city: "Teaneck, NJ",
          isCompleted: true,
          endDate: '11/22/2024'),
    ],
  ),
];
