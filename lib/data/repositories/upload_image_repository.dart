import 'dart:io';
import 'package:bek_shop/data/models/responses/upload_image_response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadImageRepository {
  /// Upload Category Images to Storage
  Future<UploadImageResponse> uploadCategoryImage({required File? imageFile}) async {
    UploadImageResponse uploadImageResponse = UploadImageResponse();
    if (imageFile != null) {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = "upload/$fileName";

      try {
        await Supabase.instance.client.storage.from("category_images").upload(path, imageFile);
        uploadImageResponse.data = Supabase.instance.client.storage
            .from("category_images")
            .getPublicUrl(path);
      } catch (error) {
        uploadImageResponse.errorMessage = error.toString();
      }
      return uploadImageResponse;
    } else {
      return uploadImageResponse;
    }
  }

  /// Upload Product Images to Storage
  Future<UploadImageResponse> uploadProductImage({required File? imageFile}) async {
    UploadImageResponse uploadImageResponse = UploadImageResponse();
    if (imageFile != null) {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = "upload/$fileName";

      try {
        await Supabase.instance.client.storage.from("product_images").upload(path, imageFile);
        final String publicUrl = Supabase.instance.client.storage
            .from("product_images")
            .getPublicUrl(path);
        uploadImageResponse.data = publicUrl;
      } catch (error) {
        uploadImageResponse.errorMessage = error.toString();
      }
      return uploadImageResponse;
    } else {
      return uploadImageResponse;
    }
  }
}
