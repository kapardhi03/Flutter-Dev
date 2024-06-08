import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  Future<String> getResponse(String prompt) async {
    String apikey = 'YOUR_API_KEY';
    try {
      if (prompt.isNotEmpty) {
        var response = await http.post(
            Uri.parse(""),
            headers: {
              "Authorization": "Bearer $apikey",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "model": "gpt-3.5-turbo",
              "messages": [
                {"role": "user", "content": prompt}
              ]
            }));
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          return json["choices"][0]["message"]["content"].toString().trimLeft();
        } else {
          return "Error: ${response.statusCode}";
        }
      } else {
        return "Error: Prompt is empty";
      }
    } on Exception catch (e) {
      return "Error: $e";
    }
  }
}
