import 'package:flutter/material.dart';

class AdminTable extends StatelessWidget {
  const AdminTable({
    super.key,
    required this.headers,
    required this.rows,
    this.onRowTap,
    this.isLoading = false,
  });

  final List<String> headers;
  final List<List<Widget>> rows;
  final Function(int)? onRowTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: headers.map((header) {
                  return SizedBox(
                    width: 160, // Fixed width for each column
                    child: Text(
                      header,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Table Body
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            ...rows.asMap().entries.map((entry) {
              final int index = entry.key;
              final List<Widget> row = entry.value;
              
              return InkWell(
                onTap: onRowTap != null ? () => onRowTap!(index) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: row.map((cell) {
                        return SizedBox(
                          width: 160, // Fixed width for each column
                          child: cell,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

class AdminTableCell extends StatelessWidget {
  const AdminTableCell({
    super.key,
    required this.child,
    this.alignment = TextAlign.start,
  });

  final Widget child;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _getAlignment(),
      child: child,
    );
  }

  Alignment _getAlignment() {
    switch (alignment) {
      case TextAlign.start:
        return Alignment.centerLeft;
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.end:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    required this.color,
  });

  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
