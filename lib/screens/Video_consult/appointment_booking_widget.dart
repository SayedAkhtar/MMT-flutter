import 'package:MyMedTrip/controller/controllers/teleconsult_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/CustomAppBar.dart';
import '../../models/doctor.dart';

class AppointmentBookingWidget extends StatefulWidget {
  const AppointmentBookingWidget({super.key, required this.doctor});
  final Doctor doctor;

  @override
  _AppointmentBookingWidgetState createState() => _AppointmentBookingWidgetState();
}

class _AppointmentBookingWidgetState extends State<AppointmentBookingWidget> {
  late List<String> availableDays = widget.doctor.timeSlots!.keys.toList();
  late Map<String, List<DoctorTimeSlot>> availableTimings = widget.doctor.timeSlots!;

  String selectedDay = '';
  List<DoctorTimeSlot> selectedTimings = [];

  @override
  void initState() {
    super.initState();
    if (availableDays.isNotEmpty) {
      selectedDay = availableDays.first;
      selectedTimings = availableTimings[selectedDay] ?? [];
    }
  }

  void _onDaySelected(String day) {
    setState(() {
      selectedDay = day;
      selectedTimings = availableTimings[day] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: 'Choose your preferred slot'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Select a day:'.tr,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableDays.length,
                itemBuilder: (context, index) {
                  final day = availableDays[index];
                  return GestureDetector(
                    onTap: () => _onDaySelected(day),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedDay == day ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(day, style: TextStyle(color: selectedDay == day ? Colors.white : Colors.black)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                '${"Available timings for".tr} $selectedDay:',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: selectedTimings.length,
                itemBuilder: (context, index) {
                  final timing = selectedTimings[index];
                  return ListTile(
                    title: Text(timing.time!),
                    onTap: () {
                      Get.find<TeleconsultController>().confirmAppointmentSlot(selectedTimings[index], widget.doctor.price, widget.doctor.id!);
                      // Handle the selected timing here, e.g., book appointment, show confirmation dialog, etc.
                      // You can also navigate to a different screen for further actions.
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}