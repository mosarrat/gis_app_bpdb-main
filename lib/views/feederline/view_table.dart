import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../api/feederline_api.dart';
import '../../models/feederlines_lookup/feederline.dart';
import '../../widgets/widgets/fieldset_legend.dart';
import 'details_feederline.dart';
// import 'update_feederline.dart';
import 'update_feederline_exp.dart';

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

  void _setLoading(bool loading) {
    if (isLoading != loading) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Feeder Lines',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 161, 182),
      ),
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
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
            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: PaginatedDataTable(
                  columns: _buildColumns(),
                  // ignore: deprecated_member_use
                  dataRowHeight: 120,
                  source: FeederLinesDataSource(snapshot.data!, context),
                  rowsPerPage: 10,
                  columnSpacing: 18,
                  horizontalMargin: 5,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(
        label: Text(
          'Feeder Line Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }
}

class FeederLinesDataSource extends DataTableSource {
  final List<FeederLines> feederLines;
  final CallApiService apiService = CallApiService();
  final BuildContext context;

  FeederLinesDataSource(this.feederLines, this.context);

  Future<void> _loadData() async {
    final newData = await apiService.fetchFeederLines();
    feederLines.clear();
    feederLines.addAll(newData);
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final feederLine = feederLines[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            width: 300,
            height: 120,
            margin: const EdgeInsets.fromLTRB(5, 8, 0, 0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feederLine.feederLineId.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Name: ${feederLine.feederlineName}\nCode: ${feederLine.feederLineCode}',
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Container(
            width: 50,
            height: 120,
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionIcon(
                  icon: Icons.edit,
                  color: Colors.blue,
                  tooltip: 'Edit',
                  onPressed: () {
                    // showEditDialog(context, apiService, feederLine, _loadData);
                    showEditForm(context, apiService, feederLine, _loadData);
                  },
                ),
                const SizedBox(height: 4),
                _buildActionIcon(
                  icon: Icons.info,
                  color: Colors.green,
                  tooltip: 'View Details',
                  onPressed: () {
                    showDetailDialog(context, apiService, feederLine);
                  },
                ),
                const SizedBox(height: 4),
                _buildActionIcon(
                  icon: Icons.delete,
                  color: Colors.red,
                  tooltip: 'Delete Data',
                  onPressed: () async {
                      if (feederLine.feederLineId != null) {
                      final shouldDelete = await showDeleteConfirmationDialog(context);
                      if (shouldDelete == true) {
                        try {
                          await apiService.deleteData(feederLine.feederLineId!);
                          _loadData();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Feeder Line Info Deleted Successfully'),
                            backgroundColor: Colors.green),
                          );
                        } catch (error) {
                          print('Error deleting Feeder Line: $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete Feeder Line: $error')),
                          );
                        }
                      }
                    } else {
                      print('Feeder Line Id is null, cannot delete.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cannot delete: Feeder Line Id is null')),
                      );
                    }
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
