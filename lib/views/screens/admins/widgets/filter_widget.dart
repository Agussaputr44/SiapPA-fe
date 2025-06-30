import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class FilterWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final List<String> months;
  final String selectedMonth;
  final List<String> years;
  final String selectedYear;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<String?>? onMonthChanged;
  final ValueChanged<String?>? onYearChanged;

  const FilterWidget({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.months,
    required this.selectedMonth,
    required this.years,
    required this.selectedYear,
    this.onCategoryChanged,
    this.onMonthChanged,
    this.onYearChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Category
        Expanded(
          flex: 4,
          child: _FilterDropdown(
            items: categories,
            value: selectedCategory,
            onChanged: onCategoryChanged,
          ),
        ),
        const SizedBox(width: 10),
        // Month
        Expanded(
          flex: 3,
          child: _FilterDropdown(
            items: months,
            value: selectedMonth,
            onChanged: onMonthChanged,
          ),
        ),
        const SizedBox(width: 10),
        // Year
        Expanded(
          flex: 2,
          child: _FilterDropdown(
            items: years,
            value: selectedYear,
            onChanged: onYearChanged,
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final List<String> items;
  final String value;
  final ValueChanged<String?>? onChanged;

  const _FilterDropdown({
    Key? key,
    required this.items,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE6E8EB)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
        dropdownColor: Colors.white,
        items: items.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(e, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}