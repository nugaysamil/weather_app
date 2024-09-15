import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import 'package:weather_app/product/utility/string_const.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _buildBackgroundShapes(),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                  builder: (context, state) {
                    if (state is WeatherBlocSuccess) {
                      return _buildWeatherContent(state);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return const Stack(
      children:  [
        Align(
          alignment: AlignmentDirectional(3, -0.3),
          child: CircleShape(color: Colors.deepPurple),
        ),
        Align(
          alignment: AlignmentDirectional(-3, -0.3),
          child: CircleShape(color: Color(0xFF673AB7)),
        ),
        Align(
          alignment: AlignmentDirectional(0, -1.4),
          child: RectangleShape(color: Color(0xFFFFAB40)),
        ),
      ],
    );
  }

  Widget _buildWeatherContent(WeatherBlocSuccess state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.weather.areaName!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            StringConstant.goodMorning,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Center(child: WeatherIcon(code: state.weather.weatherConditionCode!)),
          Center(
            child: Text(
              '${state.weather.temperature!.celsius!.round()}C',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              state.weather.weatherMain!.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              DateFormat('EEEE dd -').add_jm().format(state.weather.date!),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(height: 30),
          _buildSunInfo(state),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Divider(color: Colors.grey),
          ),
          _buildTemperatureInfo(state),
        ],
      ),
    );
  }

  Widget _buildSunInfo(WeatherBlocSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SunInfo(
          icon: StringConstant.sunriseIcon,
          label: StringConstant.sunrise,
          time: DateFormat().add_jm().format(state.weather.sunrise!),
        ),
        SunInfo(
          icon: StringConstant.sunsetIcon,
          label: StringConstant.sunset,
          time: DateFormat().add_jm().format(state.weather.sunset!),
        ),
      ],
    );
  }

  Widget _buildTemperatureInfo(WeatherBlocSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TemperatureInfo(
          icon: StringConstant.tempMaxIcon,
          label: StringConstant.tempMax,
          temperature: '${state.weather.tempMax!.celsius!.round()} C',
        ),
        TemperatureInfo(
          icon: StringConstant.tempMinIcon,
          label: StringConstant.tempMin,
          temperature: '${state.weather.tempMin!.celsius!.round()} C',
        ),
      ],
    );
  }
}

class WeatherIcon extends StatelessWidget {
  final int code;

  const WeatherIcon({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    if (code >= 200 && code < 300) {
      return Image.asset(StringConstant.weatherIcon1, scale: 8);
    } else if (code >= 300 && code < 400) {
      return Image.asset(StringConstant.weatherIcon2, scale: 8);
    } else if (code >= 500 && code < 600) {
      return Image.asset(StringConstant.weatherIcon3, scale: 8);
    } else if (code >= 600 && code < 700) {
      return Image.asset(StringConstant.weatherIcon4, scale: 8);
    } else if (code >= 700 && code < 800) {
      return Image.asset(StringConstant.weatherIcon5, scale: 8);
    } else if (code == 800) {
      return Image.asset(StringConstant.weatherIcon6);
    } else {
      return Image.asset(StringConstant.weatherIcon7);
    }
  }
}

class CircleShape extends StatelessWidget {
  final Color color;

  const CircleShape({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class RectangleShape extends StatelessWidget {
  final Color color;

  const RectangleShape({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 600,
      decoration: BoxDecoration(color: color),
    );
  }
}

class SunInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String time;

  const SunInfo({super.key, required this.icon, required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, scale: 8),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class TemperatureInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String temperature;

  const TemperatureInfo(
      {super.key, required this.icon, required this.label, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(icon, scale: 8),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 5),
            Text(
              temperature,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
