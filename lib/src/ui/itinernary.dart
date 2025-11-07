import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ItinernaryScreen extends StatefulWidget {
  final Map<String, dynamic> itinerary;

  const ItinernaryScreen({super.key, required this.itinerary});

  @override
  State<ItinernaryScreen> createState() => _ItinernaryScreenState();
}

class _ItinernaryScreenState extends State<ItinernaryScreen> {
  int _selectedDay = 0;
  String _selectedSuggestionType =
      'Restaurants'; // Toggle between Restaurants and Hotels

  List<dynamic> get days => widget.itinerary['days'] ?? [];

  List<dynamic> get activities =>
      (days.isNotEmpty && days.length > _selectedDay)
          ? days[_selectedDay]['activities'] ?? []
          : [];

  List<dynamic> get restaurants =>
      widget.itinerary['nearbySuggestions']?['restaurants'] ?? [];

  List<dynamic> get hotels =>
      widget.itinerary['nearbySuggestions']?['hotels'] ?? [];

  // Get current suggestions based on toggle
  List<dynamic> get currentSuggestions =>
      _selectedSuggestionType == 'Restaurants' ? restaurants : hotels;

  // Get map center
  LatLng getMapCenter() {
    try {
      if (days.isNotEmpty && (days[0]['activities'] as List).isNotEmpty) {
        final firstActivity = days[0]['activities'][0];
        if (firstActivity['latitude'] != null &&
            firstActivity['longitude'] != null) {
          return LatLng(
            (firstActivity['latitude'] as num).toDouble(),
            (firstActivity['longitude'] as num).toDouble(),
          );
        }
      }
    } catch (e) {
      // Fallback
    }
    return const LatLng(51.509364, -0.128928);
  }

  // Get all activity markers for the current day
  List<Marker> getActivityMarkers() {
    List<Marker> markers = [];
    for (var activity in activities) {
      if (activity['latitude'] != null && activity['longitude'] != null) {
        markers.add(
          Marker(
            point: LatLng(
              (activity['latitude'] as num).toDouble(),
              (activity['longitude'] as num).toDouble(),
            ),
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_pin,
              color: Color(0xFF00A3FF),
              size: 40,
            ),
          ),
        );
      }
    }
    return markers;
  }

  // Open Google Maps with location
  Future<void> _openInMaps(
    double? latitude,
    double? longitude,
    String? name,
  ) async {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location coordinates not available')),
      );
      return;
    }

    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    final Uri url = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open maps')));
      }
    }
  }

  // Open map for the center location
  Future<void> _openMapForDay() async {
    final center = getMapCenter();
    await _openInMaps(
      center.latitude,
      center.longitude,
      'Day ${_selectedDay + 1} Activities',
    );
  }

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
                  onPressed: () => context.pop(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      context.push('/edit-itinerary', extra: widget.itinerary);
                    },
                    child: const Text(
                      'Customize',
                      style: TextStyle(color: Color(0xFF00A3FF), fontSize: 16),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                    left: 24,
                    bottom: 16,
                    right: 24,
                  ),
                  title: Text(
                    widget.itinerary['tripName'] ?? 'Your Itinerary',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
                      // Enhanced map with tap to open
                      InkWell(
                        onTap: _openMapForDay,
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 180,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: FlutterMap(
                                  options: MapOptions(
                                    initialCenter: getMapCenter(),
                                    initialZoom: 13,
                                    interactionOptions:
                                        const InteractionOptions(
                                          flags:
                                              InteractiveFlag
                                                  .none, // Disable interaction
                                        ),
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                      userAgentPackageName:
                                          'com.example.smart_traveller_app',
                                    ),
                                    MarkerLayer(markers: getActivityMarkers()),
                                  ],
                                ),
                              ),
                            ),
                            // Overlay with "Tap to open in Maps"
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.map,
                                      color: Color(0xFF00A3FF),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Open in Maps',
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildActivityList(),
              _buildNearbySuggestions(),
            ],
          )
          .animate()
          .fade(duration: 500.ms)
          .slide(begin: const Offset(0, 0.1), duration: 500.ms),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.refresh, color: Colors.white),
        backgroundColor: const Color(0xFF00A3FF),
        label: const Text('Regenerate', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildDaySelector() {
    if (days.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dayNum = index + 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text('Day $dayNum'),
              selected: _selectedDay == index,
              onSelected: (selected) {
                if (selected) setState(() => _selectedDay = index);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFF00A3FF),
              labelStyle: TextStyle(
                color: _selectedDay == index ? Colors.white : Colors.black,
                fontWeight:
                    _selectedDay == index ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityList() {
    if (activities.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('No activities planned for this day.')),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final activity = activities[index] as Map<String, dynamic>;
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
                    activity['title'] ?? 'Activity',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      activity['time'] ?? 'All day',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  shape: const Border(),
                  childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
                  children: [
                    InkWell(
                      onTap:
                          () => _openInMaps(
                            activity['latitude'] as double?,
                            activity['longitude'] as double?,
                            activity['title'],
                          ),
                      child: _buildDetailRow(
                        Icons.location_on,
                        activity['location'] ?? 'Not specified',
                        isClickable:
                            activity['latitude'] != null &&
                            activity['longitude'] != null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.access_time_filled,
                      activity['time'] ?? 'All day',
                    ),
                    if (activity['estimatedCost'] != null) ...[
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        Icons.attach_money,
                        '\#${activity['estimatedCost']}',
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      activity['description'] ?? 'No description provided.',
                      style: TextStyle(color: Colors.grey[700], height: 1.5),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: Duration(milliseconds: index * 50))
              .slideX(begin: 0.1, duration: 300.ms);
        }, childCount: activities.length),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String text, {
    bool isClickable = false,
  }) {
    return Container(
      padding:
          isClickable
              ? const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
              : EdgeInsets.zero,
      decoration:
          isClickable
              ? BoxDecoration(
                color: const Color(0xFFE0F7FF).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              )
              : null,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isClickable ? const Color(0xFF00A3FF) : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isClickable ? const Color(0xFF00A3FF) : Colors.grey[800],
                fontWeight: isClickable ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (isClickable)
            const Icon(Icons.open_in_new, size: 16, color: Color(0xFF00A3FF)),
        ],
      ),
    );
  }

  Widget _buildNearbySuggestions() {
    // If both are empty, don't show section
    if (restaurants.isEmpty && hotels.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    print(restaurants);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Nearby Suggestions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                _buildNearbyFilterChip("Restaurants", restaurants.isNotEmpty),
                const SizedBox(width: 8),
                _buildNearbyFilterChip("Hotels", hotels.isNotEmpty),
              ],
            ),
            // const SizedBox(height: 16),
            if (currentSuggestions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    'No ${_selectedSuggestionType.toLowerCase()} available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion =
                      currentSuggestions[index] as Map<String, dynamic>;
                  return _buildSuggestionCard(suggestion);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyFilterChip(String label, bool isAvailable) {
    final isSelected = _selectedSuggestionType == label;
    return GestureDetector(
      onTap:
          isAvailable
              ? () {
                setState(() {
                  _selectedSuggestionType = label;
                });
              }
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF00A3FF)
                  : (isAvailable ? Colors.grey[200] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF00A3FF)
                    : (isAvailable
                        ? Colors.grey.shade300
                        : Colors.grey.shade200),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : (isAvailable ? Colors.black87 : Colors.grey[400]),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    final isRestaurant = _selectedSuggestionType == 'Restaurants';

    return InkWell(
      onTap:
          () => _openInMaps(
            suggestion['latitude'] as double?,
            suggestion['longitude'] as double?,
            suggestion['name'],
          ),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'suggestion_${suggestion['name']}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  suggestion['image'] ??
                      'https://placehold.co/80x80/E0F7FF/00A3FF?text=${isRestaurant ? 'Food' : 'Hotel'}',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isRestaurant ? Icons.restaurant : Icons.hotel,
                        color: const Color(0xFF00A3FF),
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion['name'] ??
                        (isRestaurant ? 'Restaurant' : 'Hotel'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${suggestion['rating'] ?? 0} (${suggestion['reviews'] ?? 0} reviews)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion['details'] ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (suggestion['priceRange'] != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      suggestion['priceRange'],
                      style: const TextStyle(
                        color: Color(0xFF00A3FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.map, color: Color(0xFF00A3FF), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'View on Maps',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100)).slideX(begin: 0.1);
  }
}
