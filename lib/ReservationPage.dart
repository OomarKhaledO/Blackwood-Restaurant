import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationPage extends StatefulWidget {
  final VoidCallback onBack;

  const ReservationPage({super.key, required this.onBack});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int _guests = 2;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '7:00 PM';

  bool _isLoading = false;
  bool _submitted = false;

  final List<String> _timeSlots = [
    '12:00 PM', '1:00 PM', '2:00 PM',
    '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM',
  ];

  // Open the date picker dialog
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD5AE33),
              surface: Color(0xFF221919),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // Save to Firestore and show success screen
  Future<void> _submitReservation() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      print(FirebaseAuth.instance.currentUser);
      if (user == null) {
        throw Exception("User not logged in");
      }

      await FirebaseFirestore.instance
          .collection('reservations')
          .add({
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'guests': _guests,
        'date': Timestamp.fromDate(_selectedDate),
        'time': _selectedTime,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      setState(() {
        _submitted = true;
        _isLoading = false;
      });

    } catch (e) {

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF221919),
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _submitted ? _buildSuccessScreen() : _buildForm(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Header bar with back button
  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF181818),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD5AE33)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back, color: Color(0xFFD5AE33)),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Reserve a Table',
                        style: TextStyle(
                          fontFamily: 'Alura',
                          fontSize: 32,
                          color: Color(0xFFD5AE33),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Container(height: 2, color: const Color(0xFFD5AE33)),
          ],
        ),
      ),
    );
  }

  // The form — email (read-only), guests, date, time
  Widget _buildForm() {
    final user = FirebaseAuth.instance.currentUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          const SizedBox(height: 20),

          // Number of guests
          _buildLabel('Guests'),

          Row(
            children: [
              _guestButton(Icons.remove, () {
                if (_guests > 1) {
                  setState(() => _guests--);
                }
              }),

              Expanded(
                child: Center(
                  child: Text(
                    '$_guests Guests',
                    style: const TextStyle(
                      color: Color(0xFFD5AE33),
                      fontSize: 28,
                      fontFamily: 'Alura',
                    ),
                  ),
                ),
              ),

              _guestButton(Icons.add, () {
                if (_guests < 20) {
                  setState(() => _guests++);
                }
              }),
            ],
          ),

          const SizedBox(height: 20),

          // Date picker
          _buildLabel('Date'),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF221919),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFFD5AE33)),
                  const SizedBox(width: 16),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFFD5AE33)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Time slots
          _buildLabel('Time'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _timeSlots.map((time) {

              final bool selected = time == _selectedTime;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTime = time;
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),

                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFD5AE33)
                        : const Color(0xFF221919),

                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(
                      color: const Color(0xFFD5AE33),
                      width: 1.5,
                    ),
                  ),

                  child: Text(
                    time,
                    style: TextStyle(
                      color: selected
                          ? Colors.black
                          : const Color(0xFFD5AE33),

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // Submit button
          _isLoading
              ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD5AE33)))
              : GestureDetector(
            onTap: _submitReservation,
            child: Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'Confirm Reservation',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Alura',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gold label above each field
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD5AE33),
          fontFamily: 'Alura',
          fontSize: 18,
        ),
      ),
    );
  }
  Widget _guestButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF221919),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD5AE33),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFD5AE33),
        ),
      ),
    );
  }
  // Success screen after booking
  Widget _buildSuccessScreen() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF221919),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFD5AE33), width: 1.5),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle,
                    color: Color(0xFFD5AE33), size: 70),
                const SizedBox(height: 20),
                const Text(
                  'Reservation Sent!',
                  style: TextStyle(
                    fontFamily: 'Alura',
                    fontSize: 34,
                    color: Color(0xFFD5AE33),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'We received your request.\nSee you soon!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70, fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 20),
                Container(
                    height: 1,
                    color: const Color(0xFFD5AE33).withOpacity(0.3)),
                const SizedBox(height: 16),
                _summaryRow(
                  'Date',
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                ),
                _summaryRow('Time', _selectedTime),
                _summaryRow('Guests', '$_guests'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD5AE33),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Alura',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 14)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}