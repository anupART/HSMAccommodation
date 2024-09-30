import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool isCalendarVisible = false;
  Map<int, bool> expansionState = {};
  TextEditingController searchController = TextEditingController();
  bool showFilteredCards = false;
  List<Employee> filteredEmployees = employees;
  bool isFilterApplied = false;

  int? selectedMonth;
  int? selectedYear;

  void _onApplyPressed() {
    setState(() {
      showFilteredCards = true;
    });
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees.where((employee) {
          return employee.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _filterEmployeesByMonthYear(int month, int year) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        return employee.events.any((event) {
          DateTime startDate = DateFormat('dd/MM/yyyy').parse(event.startDate);
          return startDate.month == month && startDate.year == year;
        });
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: const Text(
      //     'History',
      //     style: TextStyle(
      //         color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      _filterEmployees(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search by Employee name and Designation',
                      hintStyle:
                      TextStyle(color: Colors.grey[500], fontSize: 16),
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
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
                Container(
                  height: 35,
                  width: 35,
                  decoration: const BoxDecoration(
                    // color: isFilterApplied ? Colors.transparent : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        if (isFilterApplied) {
                          isFilterApplied = false;
                          isCalendarVisible = false;
                          showFilteredCards = false;
                          filteredEmployees = employees;
                        } else {
                          isFilterApplied = true;
                          isCalendarVisible = true;
                        }
                      });
                    },
                    icon: Icon(
                      isFilterApplied
                          ? Icons.clear_outlined
                          : Icons.filter_alt_sharp,
                      color: isFilterApplied
                          ? Colors.red
                          : Colors.deepOrangeAccent,
                      size: isFilterApplied ? 25 : 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          if (isCalendarVisible)
            SizedBox(
              height: 70,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<int>(
                          dropdownColor: Colors.white,
                          value: selectedMonth,
                          hint: const Text('Select Month'),
                          items: List.generate(12, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(DateFormat('MMMM')
                                  .format(DateTime(0, index + 1))),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value;
                            });
                          },
                        ),
                        DropdownButton<int>(
                          dropdownColor: Colors.white,
                          value: selectedYear,
                          hint: const Text('Select Year'),
                          items: List.generate(5, (index) {
                            int currentYear = DateTime.now().year;
                            return DropdownMenuItem(
                              value: currentYear - index,
                              child: Text('${currentYear - index}'),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              selectedYear = value;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedMonth != null && selectedYear != null) {
                              _onApplyPressed();
                              _filterEmployeesByMonthYear(
                                  selectedMonth!, selectedYear!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select both month and year')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.deepOrangeAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: showFilteredCards
                ? ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: employee.events.map((event) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Card(
                        color: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(employee.name),
                          subtitle: Text(employee.designation),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Start Date: ${event.startDate}"),
                              Text("End Date: ${event.endDate}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
                : ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = filteredEmployees[index];
                final isExpanded = expansionState[index] ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
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
                        onPressed: () {},
                        child: const Text(
                          "Generate Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )
                          : const Icon(Icons.expand_more,
                          color: Colors.grey),
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
                                minHeight: employee.events.length <= 4
                                    ? 100
                                    : 200,
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
                                      employee.events.length,
                                          (eventIndex) {
                                        final event =
                                        employee.events[eventIndex];
                                        return TimelineTile(
                                          nodeAlign: TimelineNodeAlign.start,
                                          contents: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
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
                                                            FontWeight
                                                                .bold)),
                                                    const SizedBox(width: 10),
                                                    const Text("to",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .black54)),
                                                    const SizedBox(width: 10),
                                                    Text(event.endDate,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold)),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(10),
                                                      border: Border.all(
                                                          color: Colors
                                                              .black12)),
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
                                                      : Colors
                                                      .deepOrangeAccent,
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
          )
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
        startDate: "01/01/2024",
        endDate: "01/01/2024",
        city: "Alexandria, VA",
        isCompleted: false,
      ),
      RouteEvent(
        startDate: "03/01/2024",
        endDate: "03/01/2024",
        city: "Alexandria, VA",
        isCompleted: true,
      ),
    ],
  ),
  Employee(
    name: 'Ajgf Smith',
    designation: 'Field Coordinator',
    events: [
      RouteEvent(
        startDate: "02/12/2024",
        endDate: "02/12/2024",
        city: "Philadelphia, PA",
        isCompleted: false,
      ),
      RouteEvent(
        startDate: "04/10/2024",
        endDate: "07/10/2024",
        city: "Philadelphia, PA",
        isCompleted: true,
      ),
      RouteEvent(
        startDate: "02/12/2024",
        endDate: "02/12/2024",
        city: "Philadelphia, PA",
        isCompleted: true,
      ),
      RouteEvent(
        startDate: "06/05/2024",
        endDate: "06/06/2024",
        city: "Philadelphia, PA",
        isCompleted: true,
      ),
      RouteEvent(
        startDate: "05/06/2024",
        endDate: "05/07/2024",
        city: "Philadelphia, PA",
        isCompleted: true,
      ),
      RouteEvent(
        startDate: "08/02/2024",
        endDate: "18/02/2024",
        city: "Hackensack, NJ",
        isCompleted: true,
      ),
    ],
  ),
  Employee(
    name: 'Mark Johnson',
    designation: 'Logistics Supervisor',
    events: [
      RouteEvent(
        startDate: "09/10/2023",
        endDate: "09/12/2024",
        city: "South Hackensack, NJ",
        isCompleted: false,
      ),
    ],
  ),
  Employee(
    name: 'Krup Lfhdk',
    designation: 'Logistics Supervisor',
    events: [
      RouteEvent(
        startDate: "10/03/2024",
        endDate: "10/06/2023",
        city: "South Hackensack, NJ",
        isCompleted: false,
      ),
      RouteEvent(
        startDate: "11/05/2024",
        endDate: "11/09/2024",
        city: "Teaneck, NJ",
        isCompleted: true,
      ),
    ],
  ),
];
