import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomDropDownButton extends FormField<String> {
  final String listName;
  final Map<String, dynamic> items;
  final ValueChanged<String?>? onChanged;

  CustomDropDownButton({
    Key? key,
    required this.items,
    required this.listName,
    this.onChanged,
    FormFieldValidator<String>? validator,
  }) : super(
          key: key,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: DropdownSearch<String>(
                items: items.keys.toList(),
                selectedItem: state.value,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "$listName Seçiniz",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorText: state.errorText,
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      labelText: "Ara",
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(items[item] is Map
                          ? items[item]['name'] as String
                          : items[item] as String),
                    );
                  },
                ),
                onChanged: (item) {
                  state.didChange(item);
                  if (onChanged != null) {
                    onChanged!(item);
                  }
                },
                dropdownBuilder: (context, selectedItem) {
                  return Text(selectedItem == null
                      ? ''
                      : items[selectedItem] is Map
                          ? items[selectedItem]['name'] as String
                          : items[selectedItem] as String);
                },
              ),
            );
          },
        );
}
