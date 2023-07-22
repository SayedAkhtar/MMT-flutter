import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Debouncer.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../helper/Utils.dart';

class CustomAutocomplete extends StatefulWidget  {
  CustomAutocomplete({super.key, required this.searchTable, this.selectedId, this.onSelected, this.initialValue, this.hintText, this.isRequired = false, this.patientId});
  final String searchTable;
  RxInt? selectedId;
  Function? onSelected;
  String? initialValue;
  String? hintText;
  bool isRequired;
  int? patientId;
  static String _displayStringForOption(Result option) => option.name!;

  @override
  State<CustomAutocomplete> createState() => _CustomAutocompleteState();
}

class _CustomAutocompleteState extends State<CustomAutocomplete> {

  List<Result> searchResult =[];
  final debouncer = Debouncer(milliseconds: 500);
  bool isSearching = false;
  Result? selectedOption;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      super.initState();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
@override
  // TODO: implement mounted
  bool get mounted => super.mounted;

  Future search(term) async{
    if(mounted){
      setState(() {
        isSearching = true;
      });
      debouncer.run(() async {
        print("$base_uri/ajax-search/${widget.searchTable}?term=${term}&?patient_id=${widget.patientId}");
        Response res = await GetConnect().get("$base_uri/ajax-search/${widget.searchTable}?term=${term}&?patient_id=${widget.patientId}", headers: {"Accepts": "application/json"});
        if(res.isOk){
          var json = res.body['data'];
          if(json.isNotEmpty) {
            SearchQueryResult result = SearchQueryResult.fromJson(json);
            if (result.list!.isNotEmpty) {
              setState(() {
                searchResult = result.list!;
              });
            }
          }
          setState(() {
            isSearching = false;
            searchResult = [];
          });
        }
      });
    }
  }

  Future firstSearch() async{
    Response res = await GetConnect().get("$base_uri/ajax-search/${widget.searchTable}?patient_id=${widget.patientId}", headers: {"Accepts": "application/json"});
    if(res.isOk){
      var json = res.body['data'];
      if(json.isNotEmpty) {
        SearchQueryResult result = SearchQueryResult.fromJson(json);
        if (result.list!.isNotEmpty) {
          setState(() {
            searchResult = result.list!;
          });
        }else{
          setState(() {
            searchResult =[];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   super.initState();
    // });
    return Autocomplete<Result>(
        displayStringForOption: Utils.displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
            await firstSearch();
          });
        }
        if(textEditingValue.text.length > 2){
          await search(textEditingValue.text);
        }
        if(isSearching){
          if(searchResult.isEmpty){
            return [Result(id: 0, name: "No Result")];
          }
          return [Result(id: 0, name: "Searching....")];
        }
        return searchResult.where((option) => option.name!
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase()));
        return searchResult;
      },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(4.0)),
            ),
            child: SizedBox(
              height: 52.0 * searchResult.length,
              width: MediaQuery.of(context).size.width -
                  (CustomSpacer.S * 2), // <-- Right here !
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index).name!;
                  return InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.selectedId?.value = options.elementAt(index).id!;
                      if(widget.onSelected != null){
                        widget.onSelected!(options.elementAt(index));
                      }
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState((){
                          selectedOption = options.elementAt(index);
                        });
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(option),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        if(widget.initialValue != null){
          fieldTextEditingController.text = widget.initialValue!;
        }
        if(selectedOption != null){
          fieldTextEditingController.text = selectedOption!.name!;
        }
        return TextFormField(
          controller: fieldTextEditingController,
          validator: (text){
            if(widget.isRequired){
              return (widget.selectedId?.value == 0)? 'This field is required':null;
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(vertical: CustomSpacer.XS, horizontal: CustomSpacer.XS),
          ),
          focusNode: fieldFocusNode,
        );
      },
      // onSelected: (result){
      //   widget.selectedId?.value = result.id!;
      //   if(widget.onSelected != null){
      //     widget.onSelected!(result);
      //   }
      //   FocusManager.instance.primaryFocus?.unfocus();
      // },
    );
  }
}
