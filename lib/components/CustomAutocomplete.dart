import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/Debouncer.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:get/get.dart';

class CustomAutocomplete extends StatefulWidget  {
  CustomAutocomplete({super.key, required this.searchTable, this.selectedId, this.onSelected, this.initialValue, this.hintText, this.isRequired = false});
  final String searchTable;
  RxInt? selectedId;
  Function? onSelected;
  String? initialValue;
  String? hintText;
  bool isRequired;
  static String _displayStringForOption(Result option) => option.name!;

  @override
  State<CustomAutocomplete> createState() => _CustomAutocompleteState();
}

class _CustomAutocompleteState extends State<CustomAutocomplete> {

  List<Result> searchResult =[];
  final debouncer = Debouncer(milliseconds: 500);
  bool isSearching = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // debounce(specializationQueryText, (callback) => searchSpecializations(), time: 1.seconds);
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

        Response res = await GetConnect().get("$base_uri/admin/ajax-search/${widget.searchTable}?term=${term}", headers: {"Accepts": "application/json"});
        if(res.isOk){
          var json = res.body['data'];
          if(json.isNotEmpty) {
            SearchQueryResult result = SearchQueryResult.fromJson(json);
            print(result);
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
    Response res = await GetConnect().get("$base_uri/admin/ajax-search/${widget.searchTable}", headers: {"Accepts": "application/json"});
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
    return Autocomplete<Result>(
      displayStringForOption: CustomAutocomplete._displayStringForOption,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          await firstSearch();
        }
        if(textEditingValue.text.length > 2){
          await search(textEditingValue.text);
        }
        print(isSearching);
        if(isSearching){
          print(searchResult);
          if(searchResult.isEmpty){
            return [Result(id: 0, name: "No Result")];
          }
          return [Result(id: 0, name: "Searching....")];
        }
        return searchResult;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        if(widget.initialValue != null){
          fieldTextEditingController.text = widget.initialValue!;
        }
        return TextFormField(
          controller: fieldTextEditingController,
          validator: (text){
            if(widget.isRequired){
              return (widget.selectedId?.value == 0)? 'This field is required':null;
            }
            return null;
          },
          // onChanged: (text){
          //   if(text.length > 2){
          //     search(text);
          //   }
          // },
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
      onSelected: (result){
        widget.selectedId?.value = result.id!;
        if(widget.onSelected != null){
          widget.onSelected!(result);
        }
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
