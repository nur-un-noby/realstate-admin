import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';


final SupabaseClient client = Supabase.instance.client;

Future<String> uploadImage({required File image, required String id}) async {
  try {
    await client.storage.from('state').upload(id, image);
    final publicUrl = client.storage.from('state').getPublicUrl(id);
    return publicUrl;
  } catch (e) {
    return "https://plus.unsplash.com/premium_vector-1724310048248-d6b52e189969?w=352&dpr=1&h=367&auto=format&fit=crop&q=60&ixlib=rb-4.0.3";
  }
}
