import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> uploadToCloudinary(File file) async {
  final cloudName = "dwv7t8jvx";
  final uploadPreset = "my_upload_preset";

  final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
  );

  var request = http.MultipartRequest("POST", url);

  request.fields['upload_preset'] = uploadPreset;

  request.files.add(
    await http.MultipartFile.fromPath('file', file.path),
  );

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);

      return data['secure_url']; // 🔥 THIS IS YOUR FILE URL
    } else {
      print("Upload failed: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}