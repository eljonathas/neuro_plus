import 'package:flutter/material.dart';
import 'package:neuro_plus/core/config/theme.dart';

class AppointmentCard extends StatelessWidget {
  final String date;
  final String time;
  final String title;
  final String subtitle;
  final String appointmentId;
  final bool isMultiple;
  final bool isPaid;
  final VoidCallback onTap;
  final double? paymentAmount;

  const AppointmentCard({
    Key? key,
    required this.date,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.appointmentId,
    required this.onTap,
    this.isMultiple = false,
    this.isPaid = false,
    this.paymentAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isPaid ? AppColors.gray[100] : AppColors.blueRibbon[100],
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPaid ? AppColors.gray[500] : AppColors.blueRibbon[500],
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray[800],
                          ),
                        ),
                        Text(
                          appointmentId,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isMultiple)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blueRibbon[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'MULTIPLE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueRibbon[600],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 16,
                          color: AppColors.gray[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[500],
                          ),
                        ),
                      ],
                    ),
                    if (paymentAmount != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total payment',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray[400],
                                ),
                              ),
                              Text(
                                '\$${paymentAmount!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blueRibbon[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Pay',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isPaid)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PAID',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 