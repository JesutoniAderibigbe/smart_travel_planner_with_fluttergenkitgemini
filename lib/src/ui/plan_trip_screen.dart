import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  double _budget = 2500;
  final Set<String> _selectedInterests = {'Culture'};
  TextEditingController firstDateController = TextEditingController();
  TextEditingController secondDateController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan Your Trip',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Where to?'),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Paris, France',
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 24),

            // Add destination selection widget here
            _buildSectionTitle('When are you going?'),

            // const SizedBox(height: 24),

            //Add date picker here
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: firstDateController,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";

                        // You can use setState to update the TextField with the selected date

                        setState(() {
                          firstDateController.text = formattedDate;
                          // Update the TextField's controller or value here
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'mm/dd/yyyy',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: secondDateController,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        barrierColor: Colors.black54,
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";

                        // You can use setState to update the TextField with the selected date

                        setState(() {
                          secondDateController.text = formattedDate;
                          // Update the TextField's controller or value here
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'mm/dd/yyyy',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Who\'s coming?'),
            const TextField(
              
              decoration: InputDecoration(
                hintText: 'Number of Travelers',
              
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('What\'s your budget?'),

            Slider(
              value: _budget,
              onChanged: (value) {
                setState(() {
                  _budget = value;
                });
              },
              min: 500,
              max: 50000,
              divisions: 9,
              activeColor: const Color(0xFF00A3FF),
              inactiveColor: Colors.grey[300],
              label: '\$${_budget.round()}',
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$500', style: TextStyle(color: Colors.grey[600])),
                Text('\$5000', style: TextStyle(color: Colors.grey[600])),
              ],
            ),

            // Add date picker widget here
            const SizedBox(height: 24),
            _buildSectionTitle('What are your interests?'),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildInterestChip('Culture'),
                _buildInterestChip('Adventure'),
                _buildInterestChip('Relaxation'),
                _buildInterestChip('Nature'),
                _buildInterestChip('Food & Drink'),
                _buildInterestChip('History'),
                _buildInterestChip('Shopping'),
                _buildInterestChip('Nightlife'),
              ],
            ),

            const SizedBox(height: 48),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });

                Future.delayed(Duration(seconds: 5), () {
                  context.push('/itinerary');

                  setState(() {
                    _isLoading = false;
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0F7FF),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.black, // Optional: for contrast
                      )
                      : const Text('Generate Itinerary'),
            ),

            // Add preferences selection widget here
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle plan trip action
            //     },
            //     child: const Text('Plan My Trip'),
            //   ),
            // ),
          ],
        ),
      ).animate().fade(duration: 500.ms).slide(begin: const Offset(0, 0.1), duration: 500.ms),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    final bool isSelected = _selectedInterests.contains(
      label,
    ); // Replace with actual selection logic
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedInterests.add(label);
          } else {
            _selectedInterests.remove(label);
          }
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: const Color(0xFFE0F7FF),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF00A3FF) : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF00A3FF) : Colors.grey.shade300,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }
}
