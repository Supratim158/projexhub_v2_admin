
import 'package:admin/constants/constants.dart';
import 'package:admin/controllers/password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordTextfield extends StatelessWidget {
  const PasswordTextfield({super.key, this.controller});


  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final passController = Get.put(PasswordController());
    return Obx(() =>
        SizedBox(
          width: 500,
          child: TextFormField(
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            controller: controller,
            obscureText: passController.password,
            validator: (value){
              if(value!.isNotEmpty){
                return "This Field is required ";
              }else{
                return null;
              }
            },
            style: TextStyle(fontSize: 16, color:textWhite, fontWeight: FontWeight.normal),
            decoration: InputDecoration(
              filled: true,
              fillColor: cardBackground,
              hintText: "Enter your password",
              prefixIcon: Icon(CupertinoIcons.lock_circle, size: 22,color: textGrey,),
              suffixIcon: GestureDetector(
                onTap:(){
                  passController.setPassword = !passController.password;
                },
                child: Icon(
                  passController.password ?
                  Icons.visibility
                  : Icons.visibility_off,
                  size: 22,color: textGrey,),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,   // increase height
                horizontal: 27,
              ),
              hintStyle: TextStyle(fontSize: 15, color:textWhite, fontWeight: FontWeight.normal),
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
        )
    );
  }
}
