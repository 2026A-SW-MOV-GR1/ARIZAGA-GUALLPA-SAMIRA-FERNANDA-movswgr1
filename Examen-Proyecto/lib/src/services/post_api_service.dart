import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<ApiPost> fetchPost(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('No se pudo obtener el post solicitado.');
    }

    return ApiPost.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<ApiPost> updatePost(ApiPost post) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${post.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo actualizar el post.');
    }

    return ApiPost.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
