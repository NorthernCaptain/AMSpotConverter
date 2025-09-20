import 'package:flutter/material.dart';
import '../models/conversion_result.dart';
import '../services/conversion_service.dart';

class ConversionProvider with ChangeNotifier {
  final ConversionService _conversionService;
  ConversionResult _result = ConversionResult();
  String _currentUrl = '';

  ConversionProvider(this._conversionService);

  ConversionResult get result => _result;
  String get currentUrl => _currentUrl;

  Future<void> convertUrl(String url) async {
    if (url.trim().isEmpty) {
      _result = ConversionResult();
      _currentUrl = '';
      notifyListeners();
      return;
    }

    if (!_conversionService.isValidMusicUrl(url)) {
      _result = ConversionResult(error: 'Please enter a valid Spotify or Apple Music URL');
      _currentUrl = url;
      notifyListeners();
      return;
    }

    _result = ConversionResult(isLoading: true);
    _currentUrl = url;
    notifyListeners();

    try {
      _result = await _conversionService.convertUrl(url);
    } catch (e) {
      _result = ConversionResult(error: 'An error occurred: ${e.toString()}');
    }

    notifyListeners();
  }

  void clearResults() {
    _result = ConversionResult();
    _currentUrl = '';
    notifyListeners();
  }

  void setUrl(String url) {
    _currentUrl = url;
    notifyListeners();
  }
}