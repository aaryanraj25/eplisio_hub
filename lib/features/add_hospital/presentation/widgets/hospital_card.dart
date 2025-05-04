import 'package:eplisio_hub/features/add_hospital/data/model/hospital_model.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/widgets/info_chip.dart';
import 'package:flutter/material.dart';

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  const HospitalCard({
    Key? key,
    required this.hospital,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hospital.address,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hospital.rating != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hospital.rating!.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                InfoChip(
                  icon: Icons.location_city,
                  label: hospital.city,
                ),
                
                if (hospital.phone != null) ...[
                  const SizedBox(width: 8),
                  
                ],
              ],
            ),
            if (hospital.specialties?.isNotEmpty ?? false) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: hospital.specialties!.map((specialty) {
                  return Chip(
                    label: Text(
                      specialty,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue[50],
                    padding: const EdgeInsets.all(4),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}