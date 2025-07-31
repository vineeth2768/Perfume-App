// lib/screens/home/controller/product_controller.dart

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_application_2/screens/home/model/product_model.dart';
import 'package:flutter_application_2/services/httpservice.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final HttpService httpService = HttpService();

  RxList<Banner> carouselBanners = <Banner>[].obs;
  RxList<Brand> brands = <Brand>[].obs;
  RxList<Brand> categories = <Brand>[].obs;
  Rx<HomeField?> rfqBanner = Rx<HomeField?>(null);

  // Lists for products from 'collection' types
  RxList<Product> justLaunchedProducts = <Product>[].obs;
  RxList<Product> bestsellersProducts = <Product>[].obs;

  // New banners
  Rx<HomeField?> futureOrderBanner = Rx<HomeField?>(null);
  RxList<Banner> bannerGridItems = <Banner>[].obs;
  Rx<Banner?> bottomBanner = Rx<Banner?>(null);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final Uri url = Uri.parse(
        "https://s419.previewbay.com/fragrance-b2b-backend/api/v1/home",
      );
      final response = await httpService.get(
        url,
        token:
            "3095|uEiNnuVa08RTEeWNvforPFmiVhrxV15FsJ2A2UPi", // <--- REPLACE THIS WITH YOUR ACTUAL TOKEN
      );

      log("Products API Response: ${response.body}");

      if (response.statusCode == 200) {
        final productModel = ProductModel.fromJson(jsonDecode(response.body));
        if (productModel.data != null &&
            productModel.data!.homeFields != null) {
          // Clear previous data
          carouselBanners.clear();
          brands.clear();
          categories.clear();
          rfqBanner.value = null;
          justLaunchedProducts.clear();
          bestsellersProducts.clear();
          futureOrderBanner.value = null;
          bannerGridItems.clear();
          bottomBanner.value = null;

          for (var field in productModel.data!.homeFields!) {
            if (field.type == 'carousel' && field.carouselItems != null) {
              carouselBanners.addAll(field.carouselItems!);
            } else if (field.type == 'brands' && field.brands != null) {
              brands.addAll(field.brands!);
            } else if (field.type == 'category' && field.categories != null) {
              categories.addAll(field.categories!);
            } else if (field.type == 'rfq' && field.image != null) {
              rfqBanner.value = field;
            }
            // Handle 'collection' types that contain products
            else if (field.type == 'collection' && field.products != null) {
              if (field.name == 'Just Launched') {
                justLaunchedProducts.addAll(field.products!);
              } else if (field.name == 'Our Bestsellers') {
                bestsellersProducts.addAll(field.products!);
              }
            }
            // Handle the new 'future-order' banner
            else if (field.type == 'future-order' && field.image != null) {
              futureOrderBanner.value = field;
            }
            // Handle the new 'banner-grid'
            else if (field.type == 'banner-grid' && field.banners != null) {
              bannerGridItems.addAll(field.banners!);
            }
            // Handle the single 'banner' at the bottom
            else if (field.type == 'banner' && field.banner != null) {
              bottomBanner.value = field.banner!;
            }
          }
        } else {
          errorMessage.value = 'No data fields found in the API response.';
        }
      } else {
        errorMessage.value =
            'Failed to load products. Status Code: ${response.statusCode}';
        log("API Error: ${response.statusCode} - ${response.body}");
      }
    } on SocketException catch (e) {
      errorMessage.value =
          'No internet connection. Please check your network settings.';
      log("SocketException (No Internet): $e");
    } on HandshakeException catch (e) {
      errorMessage.value = 'Secure connection failed. Please try again later.';
      log("HandshakeException: $e");
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      log("Error in Products: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
