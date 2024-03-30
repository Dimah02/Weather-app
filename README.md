# myweather

This application displays the current weather status and forecast for your location, including cloud cover and wind speed.
I used geolocator, geocoding, weather, and intl dart packages to make it work.


This application works on Android devices, it should work on iOS but I did not test it.

#### Steps to run the application on your device:
1. You have to get an API key from [OpenWeather API](https://home.openweathermap.org/users/sign_up).
2. Copy the key and paste it in `/lib/consts.dart` inside the `OPENWEATHER_API_KEY` variable.
3. Make sure to run `flutter pub get` in the terminal to ensure that all dependencies exist
4. If you are using VS code watch this tutorial to learn how to run the application on your device [tutorial](https://appmaking.com/run-flutter-apps-on-android-device/).

