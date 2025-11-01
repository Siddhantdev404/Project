import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // Import for SystemChrome

// --- 1. DATA MODELS (PARSING JSON INTO APP MODELS) ---

// Maps API integer codes to Flutter icons and descriptions
class WeatherCondition {
  final IconData icon;
  final String description;

  const WeatherCondition(this.icon, this.description);

  // Simplified WMO Weather interpretation codes (WMO_CODE)
  static const Map<int, WeatherCondition> conditions = {
    -1: WeatherCondition(Icons.cloud_off, 'Unknown Condition'),
    0: WeatherCondition(Icons.wb_sunny_rounded, 'Clear Sky'),
    1: WeatherCondition(Icons.wb_cloudy, 'Mostly Clear'),
    2: WeatherCondition(Icons.cloud, 'Partly Cloudy'),
    3: WeatherCondition(Icons.cloud_queue, 'Overcast'),
    45: WeatherCondition(Icons.foggy, 'Fog'),
    51: WeatherCondition(Icons.grain, 'Light Drizzle'),
    61: WeatherCondition(Icons.umbrella, 'Moderate Rain'),
    66: WeatherCondition(Icons.ac_unit, 'Freezing Rain'),
    71: WeatherCondition(Icons.severe_cold_rounded, 'Light Snow'),
    80: WeatherCondition(Icons.thunderstorm, 'Rain Shower'),
    95: WeatherCondition(Icons.flash_on, 'Thunderstorm'),
  };

  static WeatherCondition fromWmoCode(int code) {
    if (conditions.containsKey(code)) {
      return conditions[code]!;
    }
    // Default to the Unknown condition (-1) if the code is not found
    return conditions[-1]!;
  }
}

class ForecastItem {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final WeatherCondition condition;

  ForecastItem({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });

  static ForecastItem fromJson(Map<String, dynamic> json, int index) {
    final wmoCode = json['weather_code'][index] as int;
    return ForecastItem(
      date: DateTime.parse(json['time'][index] as String),
      maxTemp: (json['temperature_2m_max'][index] as num).toDouble(),
      minTemp: (json['temperature_2m_min'][index] as num).toDouble(),
      condition: WeatherCondition.fromWmoCode(wmoCode),
    );
  }
}

// --- 2. REPOSITORY (CLIENT + API CALLS) ---

// UPDATED: API endpoint now uses coordinates for New Delhi, India (28.61N, 77.21E)
const String _apiUrl =
    'https://api.open-meteo.com/v1/forecast?latitude=28.61&longitude=77.21&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto';

class DomainError implements Exception {
  final String message;
  DomainError(this.message);

  @override
  String toString() => 'DomainError: $message';
}

class WeatherRepository {
  Future<List<ForecastItem>> fetchForecast() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final dailyData = jsonResponse['daily'] as Map<String, dynamic>;

        if (dailyData['time'] == null || dailyData['time'].isEmpty) {
          throw DomainError('API returned successfully but no forecast data was found.');
        }

        final int itemCount = dailyData['time'].length as int;
        List<ForecastItem> forecast = [];

        for (int i = 0; i < itemCount; i++) {
          forecast.add(ForecastItem.fromJson(dailyData, i));
        }

        return forecast;

      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw DomainError('API Request failed with status ${response.statusCode}. Check location parameters.');
      } else {
        throw DomainError('Failed to load data. Status code: ${response.statusCode}');
      }
    } on http.ClientException {
      // Handles network errors (like no internet/airplane mode)
      throw DomainError('Network Error: Could not connect to the API. Check your internet connection.');
    } on FormatException {
       throw DomainError('Data parsing error: Received malformed JSON data.');
    } catch (e) {
      throw DomainError('An unexpected error occurred: ${e.toString()}');
    }
  }
}

// --- 3. UI - VIEW MODEL (STATE MANAGEMENT) ---

enum ViewState { loading, success, error, empty }

class WeatherViewModel extends ChangeNotifier {
  ViewState _state = ViewState.loading;
  List<ForecastItem> _forecast = [];
  String _errorMessage = '';
  final WeatherRepository _repository = WeatherRepository();

  ViewState get state => _state;
  List<ForecastItem> get forecast => _forecast;
  String get errorMessage => _errorMessage;

  WeatherViewModel() {
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _forecast = await _repository.fetchForecast();
      
      if (_forecast.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
    } on DomainError catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (e) {
      _errorMessage = 'Fatal Error: ${e.toString()}';
      _state = ViewState.error;
    }
    notifyListeners();
  }
}

// --- 4. MAIN APP AND WIDGETS (RENDER) ---

void main() {
  // Set system UI colors for a cleaner look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.light, 
  ));
  runApp(const WeatherApp());
}

// Defines the custom color palette for a premium look
const Color primaryColor = Color(0xFF1E3A8A); // Deep Blue (Indigo 800)
const Color secondaryColor = Color(0xFFFACC15); // Golden Yellow
const Color backgroundColor = Color(0xFFE0F7FA); // Light Cyan
const Color cardColor = Color(0xFFFFFFFF); // Pure White

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          // Removed primaryColorDark, accentColor, and cardColor 
          // as they are not defined parameters in ColorScheme.fromSwatch
        ).copyWith(secondary: secondaryColor),
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          // ignore: deprecated_member_use
          color: primaryColor,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = WeatherViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120, // Taller AppBar for a dramatic title
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Forecast',
              style: TextStyle(
                color: cardColor,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: secondaryColor, size: 20),
                SizedBox(width: 4),
                // UPDATED: Location display text is now New Delhi, India
                Text(
                  'New Delhi, India (7 Days)',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: cardColor, size: 30),
              onPressed: viewModel.fetchWeather,
              tooltip: 'Refresh Forecast',
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, child) {
          switch (viewModel.state) {
            case ViewState.loading:
              return _buildLoadingState();
            case ViewState.error:
              return _buildErrorState(viewModel.errorMessage, viewModel.fetchWeather);
            case ViewState.empty:
              return _buildEmptyState(viewModel.fetchWeather);
            case ViewState.success:
              return _buildSuccessState(viewModel.forecast);
          }
        },
      ),
    );
  }

  // --- UI STATE WIDGETS (Handling Loading, Error, Empty) ---

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryColor),
          SizedBox(height: 16),
          Text('Fetching current conditions...', style: TextStyle(fontSize: 18, color: primaryColor)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off_rounded, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Connection Problem',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.replay, color: cardColor),
              label: const Text('RETRY CONNECTION', style: TextStyle(color: cardColor, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, color: Colors.blueGrey, size: 60),
            const SizedBox(height: 16),
            const Text(
              'No Data Found',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The search returned no forecast results for this query.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.search, color: cardColor),
              label: const Text('SEARCH AGAIN', style: TextStyle(color: cardColor, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SUCCESS STATE WIDGET (Renders Scrollable List) ---

  Widget _buildSuccessState(List<ForecastItem> forecast) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        final item = forecast[index];
        return ForecastCard(item: item);
      },
    );
  }
}

// Widget for a single forecast day card
class ForecastCard extends StatelessWidget {
  final ForecastItem item;

  const ForecastCard({super.key, required this.item});

  String _formatDate(DateTime date) {
    if (date.day == DateTime.now().day) {
      return 'Today';
    }
    // Format to a more readable day of the week
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Day of the Week
          SizedBox(
            width: 70,
            child: Text(
              _formatDate(item.date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          
          // 2. Weather Icon and Description
          Expanded(
            child: Row(
              children: [
                Icon(
                  item.condition.icon,
                  size: 32,
                  color: secondaryColor, // Use secondary color for weather emphasis
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.condition.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563), // Text-gray-600
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // 3. Temperatures (High / Low)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.maxTemp.round()}°',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              Text(
                '${item.minTemp.round()}°',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
