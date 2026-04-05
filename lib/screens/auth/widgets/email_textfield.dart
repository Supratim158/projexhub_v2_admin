
import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';

class EmailTextfield extends StatelessWidget {
  const EmailTextfield({super.key, this.onEditingComplete, this.keyboardType, this.initialValue, this.controller, this.hintText, this.prefixIcon});

  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        cursorColor: Colors.grey,
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditingComplete,
        keyboardType: keyboardType ?? TextInputType.emailAddress,
        initialValue: initialValue,
        controller: controller,
        validator: (value){
          if(value!.isNotEmpty){
            return "This Field is required ";
          }else{
            return null;
          }
        },
        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight:FontWeight.normal),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF1F1F3D),
          hintText: hintText,
          prefixIcon: prefixIcon,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            vertical: 20,   // increase height
            horizontal: 27,
          ),
          hintStyle: TextStyle(fontSize: 15, color: Colors.white, fontWeight:FontWeight.normal),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRed,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimary,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kRed,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kGray,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: kPrimary,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimary,width: .5),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
