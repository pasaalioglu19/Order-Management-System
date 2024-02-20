import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class DropDownForm extends StatefulWidget {
  const DropDownForm({
    Key? key,
    this.hintText = 'Search',
    this.width = 200,
    this.height = 60,
    this.alignment = Alignment.bottomCenter,
    this.dropDownList = const [],
    required this.onChange,
  }) : super(key: key);

  final double width;
  final double height;
  final String hintText;
  final AlignmentGeometry alignment;
  final List<DropDownValueModel> dropDownList;
  final void Function(dynamic)? onChange;

  @override
  State<DropDownForm> createState() => _DropDownFormState();
}

class _DropDownFormState extends State<DropDownForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;

  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: widget.alignment,
              child: SizedBox(
                width: widget.width,
                height: widget.height, 
                child: DropDownTextField(
                  textFieldDecoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    filled: true,
                    fillColor: const Color.fromRGBO(209, 209, 209, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Color(0xFF0A6C0E)), //Color when clicking on the form
                    ),
                    hintText: widget.hintText, 
                  ),
                  clearOption: false,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  dropDownItemCount: 5,
                  searchShowCursor: true,
                  enableSearch: true,
                  dropDownList: widget.dropDownList,
                  onChanged: widget.onChange,
                  dropdownColor: const Color(0xffC6D2C4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
