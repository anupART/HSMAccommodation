import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';
import 'history_model.dart';

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
  List<Data> filteredData = [];
  bool isFilterApplied = false;
  int? selectedMonth;
  int? selectedYear;
  List<Data> allData = [];
  String searchQuery = '';

  Future<HistoryModel> getHistoryData() async {
    final response = await http.get(Uri.parse('https://beds-accomodation.vercel.app/api/formattedBookingHistory'));

    if (response.statusCode == 200) {
      final history = jsonDecode(response.body);
      return HistoryModel.fromJson(history);
    } else {
      throw Exception('Failed to load history data');
    }
  }

  void _filterDataByMonthYear(int month, int year) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
      filteredData = allData
          .map((employeeData) {
        final filteredEvents = employeeData.bookingDetails?.where((event) {
          DateTime startDate = DateFormat('yyyy-MM-dd').parse(event.loggedInDate);
          DateTime endDate = DateFormat('yyyy-MM-dd').parse(event.loggedOutDate);
          bool isStartDateInMonthYear = startDate.month == month && startDate.year == year;
          bool isEndDateInMonthYear = endDate.month == month && endDate.year == year;
          return isStartDateInMonthYear || isEndDateInMonthYear;
        }).toList();
        if (filteredEvents != null && filteredEvents.isNotEmpty) {
          return Data(
            id: employeeData.id,
            empId: employeeData.empId,
            name: employeeData.name,
            deptName: employeeData.deptName,
            email: employeeData.email,
            bookingDetails: filteredEvents,
          );
        }
        return null;
      })
          .where((employee) => employee != null)
          .cast<Data>()
          .toList();
    });
  }

  void _searchEmployees(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      List<Data> searchResults = allData.where((employee) {
        bool nameMatches = employee.name.toLowerCase().contains(searchQuery);
        bool deptNameMatches = employee.deptName.toLowerCase().contains(searchQuery);
        return nameMatches || deptNameMatches;
      }).toList();
      if (selectedMonth != null && selectedYear != null) {
        filteredData = searchResults
            .map((employee) {
          final filteredEvents = employee.bookingDetails?.where((event) {
            DateTime startDate = DateFormat('yyyy-MM-dd').parse(event.loggedInDate);
            DateTime endDate = DateFormat('yyyy-MM-dd').parse(event.loggedOutDate);
            bool isStartDateInMonthYear = startDate.month == selectedMonth && startDate.year == selectedYear;
            bool isEndDateInMonthYear = endDate.month == selectedMonth && endDate.year == selectedYear;
            return isStartDateInMonthYear || isEndDateInMonthYear;
          }).toList();
          if (filteredEvents != null && filteredEvents.isNotEmpty) {
            return Data(
              id: employee.id,
              empId: employee.empId,
              name: employee.name,
              deptName: employee.deptName,
              email: employee.email,
              bookingDetails: filteredEvents,
            );
          }
          return null;
        })
            .where((employee) => employee != null)
            .cast<Data>()
            .toList();
      } else {
        filteredData = searchResults;
      }
    });
  }

  void _onApplyPressed() {
    setState(() {
      showFilteredCards = true;
    });
  }

  void _resetFilter() {
    setState(() {
      selectedMonth = null;
      selectedYear = null;
      filteredData = allData;
      searchQuery = '';
    });
  }

  void _filterEmployees(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = allData;
      } else {
        filteredData = allData.where((employee) {
          return employee.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getHistoryData().then((value) {
      setState(() {
        allData = value.data;
        filteredData = value.data;
      });
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
                      _searchEmployees(value);
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
                            _resetFilter();
                            isFilterApplied = false;
                            isCalendarVisible = false;
                            showFilteredCards = false;
                            filteredData = allData;
                            expansionState = { for (var index in List.generate(
                                filteredData.length, (index) => index)) index : false };
                          } else {
                            isFilterApplied = true;
                            isCalendarVisible = true;
                          }
                        });
                      },
                      icon: Icon(
                        isFilterApplied
                            ? Icons.clear_outlined
                            : Icons.filter_list,
                        color: isFilterApplied
                            ? Colors.red
                            : Colors.deepOrangeAccent,
                        size: isFilterApplied ? 25 : 35,
                      ),
                    )),
              ],
            ),
          ),
          if (isCalendarVisible)
            SizedBox(
              height: 65,
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
                              _filterDataByMonthYear(
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
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final employee = filteredData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: employee.bookingDetails!.map((event) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Card(
                              color: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.grey.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                  Colors.grey.withOpacity(0.2),
                                  radius: 25,
                                  child: Text(
                                    employee.name[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                ),
                                // trailing: Text(event.city),
                                title: Text(
                                  employee.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Room No. : ${event.roomNumber}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Bed No. : ${event.bedNumber}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      employee.deptName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16,
                                            color: Colors.orange),
                                        Text(
                                          "  Start: ${event.loggedInDate}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16,
                                            color: Colors.orange),
                                        Text(
                                          "  End: ${event.loggedOutDate}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )));
                    }).toList(),
                  );
                },
              )
                  : ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final employee = filteredData[index];
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                  employee.deptName,
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
                            backgroundColor:
                            Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
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
                          if (isExpanded)
                            Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: employee.bookingDetails!.length <= 4
                                        ? 100
                                        : 200,
                                    maxHeight: employee.bookingDetails!.length > 4
                                        ? 250
                                        : double.infinity,
                                  ),
                                  child: SingleChildScrollView(
                                    child: FixedTimeline(
                                      theme: TimelineThemeData(
                                        nodePosition: 0.1,
                                        color: Colors.grey,
                                        connectorTheme:
                                        ConnectorThemeData(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      children: List.generate(
                                          employee.bookingDetails!.length,
                                              (eventIndex) {
                                            final event =
                                            employee.bookingDetails![eventIndex];
                                            return TimelineTile(
                                              nodeAlign:
                                              TimelineNodeAlign.start,
                                              contents: Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(event.loggedInDate,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Text("to",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54)),
                                                        const SizedBox(
                                                            width: 10),
                                                        Text(event.loggedOutDate,
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Container(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black12)),
                                                      child: Text(
                                                        "  Room No.: ${event.roomNumber}, Bed No.: ${event.bedNumber} ",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .w500),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              node: TimelineNode(
                                                indicator: const Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    DotIndicator(
                                                      color: Colors.grey,
                                                      // color: event.isCompleted
                                                      //     ? Colors.grey
                                                      //     : Colors
                                                      //     .deepOrangeAccent,
                                                      size: 16,
                                                    ),
                                                    // if (event.isCompleted)
                                                    //   const Icon(
                                                    //     Icons.check,
                                                    //     color: Colors.white,
                                                    //     size: 10,
                                                    //   ),
                                                  ],
                                                ),
                                                endConnector: eventIndex !=
                                                    employee.bookingDetails!
                                                        .length +
                                                        1
                                                    ? const SolidLineConnector()
                                                    : null,
                                                startConnector: eventIndex !=
                                                    0
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
              )),
        ],
      ),
    );
  }
}