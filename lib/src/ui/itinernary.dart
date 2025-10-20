import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_traveller_app/src/models/mock_itinerary.dart';

class ItinernaryScreen extends StatefulWidget {
  const ItinernaryScreen({super.key});

  @override
  State<ItinernaryScreen> createState() => _ItinernaryScreenState();
}

class _ItinernaryScreenState extends State<ItinernaryScreen> {
  int _selectedDay = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: () => context.push('/edit-itinerary'),
                child: const Text(
                  'Customize',
                  style: TextStyle(color: Color(0xFF00A3FF), fontSize: 16),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 24, bottom: 16, right: 24),
              title: Text(
                mockItinerary['tripName'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // background: Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 24, bottom: 40),
              //     child: Text(
              //       mockItinerary['dates'],
              //       style: TextStyle(color: Colors.grey[600]),
              //     ),
              //   ),
              // ),
            ),
          ),

          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.all(24.0),
          //     child: Text(
          //       mockItinerary['dates'],
          //       style: TextStyle(color: Colors.grey[600]),
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Column(
                children: [
                  _buildDaySelector(),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://developers.google.com/static/maps/images/landing/react-codelab-thumbnail.png',
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildActivityList(),
          _buildNearbySuggestions(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.refresh, color: Colors.white),
        backgroundColor: const Color(0xFF00A3FF),

        label: const Text('Regenerate', style: TextStyle(color: Colors.white)),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(5, (index) {
          final day = index + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('Day $day'),
              selected: _selectedDay == day,
              onSelected: (selected) {
                if (selected) setState(() => _selectedDay = day);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFF00A3FF),
              labelStyle: TextStyle(
                color: _selectedDay == day ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = mockItinerary['days'][0]['activities'] as List;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final activity = activities[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            surfaceTintColor: Colors.grey[50],
            color: Colors.white,

            shadowColor: Colors.grey.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              backgroundColor: Colors.white,
              title: Text(
                activity['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              shape: const Border(),
              childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
              children: [
                _buildDetailRow(Icons.access_time_filled, activity['time']),
                const SizedBox(height: 8),
                _buildDetailRow(Icons.location_on, activity['location']),
                const SizedBox(height: 16),
                Text(
                  activity['description'],
                  style: TextStyle(color: Colors.grey[700], height: 1.5),
                ),
              ],
            ),
          );
        }, childCount: activities.length),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: Colors.grey[800]))),
      ],
    );
  }

  Widget _buildNearbySuggestions() {
    final suggestions =
        mockItinerary['nearbySuggestions']['restaurants'] as List;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: const Text(
                    'Nearby Suggestions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildNearbyFilterChip("Restaurants"),
                const SizedBox(width: 8),
                _buildNearbyFilterChip("Hotels"),
              ],
            ),

            //  const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          suggestion['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              suggestion['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${suggestion['rating']} (${suggestion['reviews']} reviews)',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              suggestion['details'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyFilterChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
