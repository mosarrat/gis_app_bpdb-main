import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/feederlines_lookup/feederline.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'details_feederline.dart';
import 'update_feederline.dart';

class ViewFeederlinesTable extends StatefulWidget {
  const ViewFeederlinesTable({super.key});

  @override
  State<ViewFeederlinesTable> createState() => _ViewFeederlinesTableState();
}

class _ViewFeederlinesTableState extends State<ViewFeederlinesTable> {
  late Future<List<FeederLines>> _futureFeederLines;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _futureFeederLines = _fetchFeederLines();
  }

  Future<List<FeederLines>> _fetchFeederLines() async {
    return CallApiService().fetchFeederLines();
  }

  void setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feeder Lines')),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: FutureBuilder<List<FeederLines>>(
        future: _futureFeederLines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Feeder Line available!'));
          } else {
            return PaginatedDataTable(
              header: const Text('Feeder Lines'),
              columns: _buildColumns(),
              source: FeederLinesDataSource(snapshot.data!),
              rowsPerPage: 5,
              columnSpacing: 12,
              horizontalMargin: 10,
              showCheckboxColumn: false,
            );
          }
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(label: Text('Details', style: TextStyle(height: 5, fontWeight: FontWeight.bold))),
      const DataColumn(label: Text('Actions', style: TextStyle(height: 5, fontWeight: FontWeight.bold))),
    ];
  }
}

class FeederLinesDataSource extends DataTableSource {
  final List<FeederLines> feederLines;

  FeederLinesDataSource(this.feederLines);

  @override
  DataRow getRow(int index) {
    final feederLine = feederLines[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                feederLine.feederLineId.toString(),
                style: const TextStyle(height: 2),
              ),
              subtitle: Text(
                'Feeder Line Name #${feederLine.feederlineName}\nCode #${feederLine.feederLineCode}',
                style: const TextStyle(height: 1.5),
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionIcon(
                  icon: Icons.edit,
                  color: Colors.blue,
                  tooltip: 'Edit',
                  onPressed: () {
                    // Handle edit action
                  },
                ),
                const SizedBox(width: 4),
                _buildActionIcon(
                  icon: Icons.info,
                  color: Colors.green,
                  tooltip: 'View Details',
                  onPressed: () {
                    // Handle view details action
                  },
                ),
                const SizedBox(width: 4),
                _buildActionIcon(
                  icon: Icons.delete,
                  color: Colors.red,
                  tooltip: 'Delete Data',
                  onPressed: () async {
                    // Handle delete action
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => feederLines.length;

  @override
  int get selectedRowCount => 0;

  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        height: 27,
        width: 27,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          iconSize: 12,
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../../api/api.dart';
// import '../../api/apiservice.dart';
// import '../../models/feederlines_lookup/feederline.dart';
// import '../../widgets/widgets/fieldset_legend.dart';
// import 'details_feederline.dart';
// import 'update_feederline.dart';

// class ViewFeederlinesTable extends StatefulWidget {
//   const ViewFeederlinesTable({super.key});

//   @override
//   State<ViewFeederlinesTable> createState() => _ViewFeederlinesTableState();
// }

// class _ViewFeederlinesTableState extends State<ViewFeederlinesTable> {
//   late Future<List<FeederLines>> _futureFeederLines;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _futureFeederLines = _fetchFeederLines();
//   }

//   Future<List<FeederLines>> _fetchFeederLines() async {
//     return CallApiService().fetchFeederLines();
//   }

//   void setLoading(bool loading) {
//     if (isLoading != loading) {
//       setState(() {
//         isLoading = loading;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ignore: deprecated_member_use
//     // double deviceFontSize = 16.0 * MediaQuery.textScaleFactorOf(context);
//     // double width = MediaQuery.of(context).size.width;
//     // double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(title: const Text('Feeder Lines')),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return SafeArea(
//       child: FutureBuilder<List<FeederLines>>(
//         future: _futureFeederLines,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No Feeder Line available!'));
//           } else {
//             return SingleChildScrollView(
//               child: PaginatedDataTable(
//                 columns: _buildColumns(),
//                 // ignore: deprecated_member_use
//                 dataRowHeight: 120,
//                 source: FeederLinesDataSource(snapshot.data!),
//                 rowsPerPage: 10,
//                 columnSpacing: 18,
//                 horizontalMargin: 5,
//                 // showCheckboxColumn: false,
//               ),
//             ); 
//           }
//         },
//       ),
//     );
//   }

//   List<DataColumn> _buildColumns() {
//     return [
//       const DataColumn(
//           label: Text('Feeder Line Details',
//               style: TextStyle(
//                   height: 5, fontSize: 16, fontWeight: FontWeight.bold))),
//       const DataColumn(
//           label: Text('Actions',
//               style: TextStyle(
//                   height: 5, fontSize: 16, fontWeight: FontWeight.bold))),
//     ];
//   }
// }

// class FeederLinesDataSource extends DataTableSource {
//   final CallApiService apiService = CallApiService();
//   late Future<List<FeederLines>> _futureFeederLines;
//   final List<FeederLines> feederLines;
  
  
//   void _loadData() {
//     setState(() {
//       _futureFeederLines = apiService.fetchFeederLines();
//     });
//   }

//   FeederLinesDataSource(this.feederLines);

//   @override
//   DataRow getRow(int index) {
//     final feederLine = feederLines[index];
//     return DataRow.byIndex(
//       index: index,
//       cells: [
//         DataCell(
//           Container(
//             width: 300,
//             height: 120,
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   feederLine.feederLineId.toString(),
//                   style: const TextStyle(
//                       height: 2.5, fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Name #${feederLine.feederlineName}\nCode #${feederLine.feederLineCode}',
//                   style: const TextStyle(height: 1.5),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         //DataCell(Text(feederLine.feederlineName)),
//         DataCell(
//           Container(
//             width: 50,
//             height: 120,
//             alignment: Alignment.centerRight,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildActionIcon(
//                   icon: Icons.edit,
//                   color: Colors.blue,
//                   tooltip: 'Edit',
//                   onPressed: () {
//                     // Handle edit action
//                     showEditDialog(context, apiService, feederLine, _loadData);
//                   },
//                 ),
//                 const SizedBox(height: 4),
//                 _buildActionIcon(
//                   icon: Icons.info,
//                   color: Colors.green,
//                   tooltip: 'View Details',
//                   onPressed: () {
//                     // Handle view details action
//                     showDetailDialog(context, apiService, feederLine);
//                   },
//                 ),
//                 const SizedBox(height: 4),
//                 _buildActionIcon(
//                   icon: Icons.delete,
//                   color: Colors.red,
//                   tooltip: 'Delete Data',
//                   onPressed: () async {
//                       if (feederLine.feederLineId != null) {
//                       final shouldDelete = await showDeleteConfirmationDialog(context);
//                       if (shouldDelete == true) {
//                         try {
//                           await apiService.deleteData(feederLine.feederLineId!);
//                           _loadData();

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Feeder Line Info Deleted Successfully'),
//                             backgroundColor: Colors.green),
//                           );
//                         } catch (error) {
//                           print('Error deleting Feeder Line: $error');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Failed to delete Feeder Line: $error')),
//                           );
//                         }
//                       }
//                     } else {
//                       print('Feeder Line Id is null, cannot delete.');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Cannot delete: Feeder Line Id is null')),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => feederLines.length;

//   @override
//   int get selectedRowCount => 0;

//   Widget _buildActionIcon({
//     required IconData icon,
//     required Color color,
//     required String tooltip,
//     required VoidCallback onPressed,
//   }) {
//     return Tooltip(
//       message: tooltip,
//       child: Container(
//         height: 27,
//         width: 27,
//         decoration: BoxDecoration(
//           color: color,
//           shape: BoxShape.circle,
//         ),
//         child: IconButton(
//           iconSize: 12,
//           icon: Icon(icon, color: Colors.white),
//           onPressed: onPressed,
//         ),
//       ),
//     );
//   }
// }
