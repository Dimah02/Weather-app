# myweather

This application shows the current weather status for your device location and it shows a forcast for the upcoming days and some information about the weather like the cloudness and wind speed..

I used geolocator, geocoding, weather and intl dart packages to make it work.


This application works on android devices, it should work on ios but I did not test it.

#### Steps to run the application on your device:
1. You have to get an api key from [OpenWeather api](https://home.openweathermap.org/users/sign_up).
2. Copy the key and paste it in `/lib/consts.dart` inside the `OPENWEATHER_API_KEY` variable.
3. Make sure to run `flutter pub get` in the terminal to ensure that all dependecies exist
4. If you are using VS code watch this toturial to know how to run the application on your device [toturial](https://appmaking.com/run-flutter-apps-on-android-device/).

