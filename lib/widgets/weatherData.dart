import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:myweather/consts.dart';
import 'package:weather/weather.dart';

class WeatherData extends StatefulWidget {
  final String city;
  final Position pos;

  const WeatherData({super.key, required this.city, required this.pos});

  @override
  State<WeatherData> createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  List<Weather>? _forecast;

  @override
  void initState() {
    super.initState();
    _wf
        .currentWeatherByLocation(widget.pos.latitude, widget.pos.longitude)
        .then((weather) {
      setState(() {
        _weather = weather;
      });
    });
    _wf
        .fiveDayForecastByLocation(widget.pos.latitude, widget.pos.longitude)
        .then((forecast) {
      setState(() {
        _forecast = forecast;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_forecast == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _locationHeader(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _currentTemp(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _minMaxTemp(),
              _weatherIcon(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _extraInfo(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              _forcast(),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      widget.city,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 64,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _minMaxTemp() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        Text(
          " / ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        )
      ],
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.90,
      decoration: BoxDecoration(
          color: const Color.fromARGB(184, 119, 171, 243),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cloud Cover: ${_weather?.cloudiness?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const Divider(
            color: Colors.white,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Pressure: ${_weather?.pressure?.toStringAsFixed(0)}hPa",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _forcast() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.37,
      width: MediaQuery.sizeOf(context).width * 0.90,
      decoration: BoxDecoration(
          color: const Color.fromARGB(184, 119, 171, 243),
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _forecast!.length,
        itemBuilder: (context, index) {
          DateTime? now = _forecast![index].date;
          return Column(
            children: [
              Text(
                DateFormat("EEE").format(now!),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${now.day}/${now.month}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('Hm', 'en_US').format(now),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "http://openweathermap.org/img/wn/${_forecast![index].weatherIcon}@2x.png"))),
              ),
              Text(
                _weather?.weatherDescription ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${_forecast![index].temperature?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return const VerticalDivider(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
