import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String date;
  final String time;
  final String appointmentId;
  final String clinicName;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String treatment;
  final String treatmentDetail;
  final double rating;
  final int reviewCount;
  final double distance;
  final bool isMultiple;
  final int duration;

  const AppointmentDetailScreen({
    super.key,
    required this.date,
    required this.time,
    required this.appointmentId,
    required this.clinicName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.treatment,
    required this.treatmentDetail,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.isMultiple,
    required this.duration,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  int _currentTabIndex = 0;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: '${widget.date} (${widget.time})',
      navIndex: _navIndex,
      isBackButtonVisible: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.arrow_back, color: AppColors.blueRibbon[500]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${widget.date} (${widget.time})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTabs(),
          const SizedBox(height: 24),
          _buildActiveTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem('Reservation detail', 0),
          _buildTabItem('Bill detail', 1),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  isSelected ? AppColors.blueRibbon[500]! : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.blueRibbon[500] : AppColors.gray[500],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    return _currentTabIndex == 0
        ? _buildReservationDetail()
        : _buildBillDetail();
  }

  Widget _buildReservationDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                '#${widget.appointmentId}',
                style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
              ),
              const SizedBox(width: 16),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blueRibbon[500],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Registered',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildClinicInfo(),
        const SizedBox(height: 20),
        _buildTreatmentInfo(),
        const SizedBox(height: 24),
        _buildMapSection(),
      ],
    );
  }

  Widget _buildClinicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gray[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business, color: AppColors.gray[400]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.clinicName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.gray[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.distance} km',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.rating} (${widget.reviewCount} reviews)',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${widget.address}, ${widget.city}, ${widget.state}, ${widget.zipCode}',
            style: TextStyle(fontSize: 14, color: AppColors.gray[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Treatment information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildTreatmentItem(),
        ],
      ),
    );
  }

  Widget _buildTreatmentItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.treatment,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      widget.isMultiple
                          ? AppColors.blueRibbon[100]
                          : Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.isMultiple ? 'MULTIPLE' : 'SINGLE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        widget.isMultiple
                            ? AppColors.blueRibbon[600]
                            : Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.treatmentDetail,
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                ),
              ),
              Text(
                '±${widget.duration} hours',
                style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.gray[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(Icons.map, size: 48, color: AppColors.gray[400]),
      ),
    );
  }

  Widget _buildBillDetail() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill information would go here',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
