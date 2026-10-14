import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'dart:io' show HttpDate;

/// Interceptor that handles Antiforgery cookies:
///
/// 1. Intercepts 'Set-Cookie' headers in responses and extracts cookies
/// 2. CookieManager handles saving all cookies normally
/// 3. This interceptor adds *only* the Antiforgery cookies to the Cookie header
///    before each request, overriding what CookieManager might have added
///
/// This ensures that only Antiforgery cookies are sent with requests
/// while still allowing all cookies to be saved
class AntiforgeryCookieInterceptor extends Interceptor {
  final PersistCookieJar cookieJar;

  AntiforgeryCookieInterceptor(this.cookieJar);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Get all cookies from the jar for this domain
      final cookies = await cookieJar.loadForRequest(options.uri);

      // Antiforgery çerezlerini filter et
      final antiforgeryCookies = cookies.where((cookie) =>
        cookie.name.endsWith('Antiforgery')
      ).toList();

      // CSRF gerektiren POST isteklerinde, hem antiforge çerezlerini hem tüm çerezleri ekle
      if (options.extra.containsKey('csrf') && options.extra['csrf'] == true) {
        if (cookies.isNotEmpty) {
          if (kDebugMode) {
            print('🍪 Adding ${cookies.length} cookies to CSRF request:');
            for (var cookie in cookies) {
              print('   - ${cookie.name}');
            }
          }

          // Tüm çerezleri ekle
          final cookieHeader = cookies.map((cookie) =>
            '${cookie.name}=${cookie.value}'
          ).join('; ');

          // Override the cookies header
          options.headers['cookie'] = cookieHeader;
        }
      }
      // Diğer isteklerde sadece antiforgery çerezlerini ekle
      else if (antiforgeryCookies.isNotEmpty) {
        if (kDebugMode) {
          print('🍪 Adding ${antiforgeryCookies.length} Antiforgery cookies to request:');
          for (var cookie in antiforgeryCookies) {
            print('   - ${cookie.name}');
          }
        }

        // Convert cookies to Cookie header format: name=value; name2=value2
        final cookieHeader = antiforgeryCookies.map((cookie) =>
          '${cookie.name}=${cookie.value}'
        ).join('; ');

        // Override the cookies header - this will replace what CookieManager set
        options.headers['cookie'] = cookieHeader;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding cookies to request: $e');
      }
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final cookies = response.headers['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        // Log all cookies for debugging
        if (kDebugMode && cookies.isNotEmpty) {
          print('🍪 Response contains ${cookies.length} cookies');
          for (var cookieString in cookies) {
            final parts = cookieString.split(';');
            if (parts.isNotEmpty) {
              final nameValue = parts[0].trim().split('=');
              if (nameValue.length == 2) {
                final name = nameValue[0].trim();
                if (name.endsWith('Antiforgery')) {
                  print('   - Antiforgery cookie found: $name');
                }
              }
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inspecting cookies in response: $e');
      }
    }
    
    // Continue with the response - CookieManager will handle saving all cookies
    handler.next(response);
  }
  
  // Save Antiforgery cookies manually if needed - not normally needed as CookieManager handles it
  Future<void> saveAntiforgeryCookies(Uri uri, List<String> cookieStrings) async {
    try {
      final antiforgeryCookies = <Cookie>[];
      
      for (var cookieString in cookieStrings) {
        // Parse cookie string
        final cookie = _parseCookie(cookieString, uri);
        
        // Only save cookies that end with 'Antiforgery'
        if (cookie != null && cookie.name.endsWith('Antiforgery')) {
          antiforgeryCookies.add(cookie);
          if (kDebugMode) {
            print('🍪 Manually saving Antiforgery cookie: ${cookie.name}');
          }
        }
      }
      
      // Save the filtered cookies
      if (antiforgeryCookies.isNotEmpty) {
        await cookieJar.saveFromResponse(uri, antiforgeryCookies);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving Antiforgery cookies: $e');
      }
    }
  }
  
  /// Parse a cookie string into a Cookie object
  Cookie? _parseCookie(String cookieString, Uri uri) {
    try {
      // Split the cookie string by ';' to separate the name-value from attributes
      final parts = cookieString.split(';');
      if (parts.isEmpty) return null;
      
      // Get the name-value part
      final nameValue = parts[0].trim().split('=');
      if (nameValue.length != 2) return null;
      
      final name = nameValue[0].trim();
      final value = nameValue[1].trim();
      
      // Create the cookie with only name and value
      final cookie = Cookie(name, value);
      
      // Set default domain and path
      cookie.domain = uri.host;
      cookie.path = '/';
      cookie.expires = DateTime.now().add(const Duration(days: 30)); // Default expiry
      cookie.httpOnly = true;
      cookie.secure = uri.scheme == 'https';
      
      // Process cookie attributes
      for (var i = 1; i < parts.length; i++) {
        final part = parts[i].trim().toLowerCase();
        
        if (part.startsWith('expires=')) {
          final dateString = part.substring('expires='.length);
          try {
            cookie.expires = HttpDate.parse(dateString);
          } catch (_) {
            // Ignore parsing errors for expires
          }
        } else if (part.startsWith('path=')) {
          cookie.path = part.substring('path='.length);
        } else if (part.startsWith('domain=')) {
          cookie.domain = part.substring('domain='.length);
        } else if (part == 'secure') {
          cookie.secure = true;
        } else if (part == 'httponly') {
          cookie.httpOnly = true;
        }
      }
      
      return cookie;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing cookie: $e');
      }
      return null;
    }
  }
}