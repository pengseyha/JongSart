const String _clinicImageFallback =
    'assets/images/clinics/jongsart_skin_clinic.jpg';
const String _doctorImageFallback = 'assets/images/doctors/dr_3.jpg';
const String _treatmentImageFallback =
    'assets/images/treatments/hydra_facial_care.jpg';

String clinicImageById(String id) {
  switch (id) {
    case 'clinic_lumina':
      return 'assets/images/clinics/jongsart_skin_clinic.jpg';
    case 'clinic_emerald':
      return 'assets/images/clinics/sovanna_aesthetic_clinic.jpg';
    case 'clinic_north_peak':
      return 'assets/images/clinics/mekong_dermatology_center.jpg';
    case 'clinic_tonle':
      return 'assets/images/clinics/tonle_skin_beauty_clinic.jpg';
    case 'clinic_ppderma':
      return 'assets/images/clinics/phnom_penh_derma_care.jpg';
    default:
      return _clinicImageFallback;
  }
}

String doctorImageById(String id) {
  switch (id) {
    case 'doctor_frances':
      return 'assets/images/doctors/dr_peng_seyha.jpg';
    case 'doctor_sreyneang':
      return 'assets/images/doctors/dr_lim_kimhorng.jpg';
    case 'doctor_sarah':
    case 'doctor_lina':
    case 'doctor_dara':
      return 'assets/images/doctors/dr_3.jpg';
    default:
      return _doctorImageFallback;
  }
}

String treatmentImageById(String id) {
  switch (id) {
    case 'treatment_hydra':
      return 'assets/images/treatments/hydra_facial_care.jpg';
    case 'treatment_blue_light':
      return 'assets/images/treatments/acne_consultation.jpg';
    case 'treatment_lactic_peel':
      return 'assets/images/treatments/brightening_facial_care.jpg';
    case 'treatment_deep_clean':
      return 'assets/images/treatments/deep_cleansing_facial.jpg';
    case 'treatment_sensitive':
      return 'assets/images/treatments/acne_consultation.jpg';
    case 'treatment_pigmentation':
      return 'assets/images/treatments/brightening_facial_care.jpg';
    case 'treatment_scar':
      return 'assets/images/treatments/deep_cleansing_facial.jpg';
    case 'treatment_antiaging':
      return 'assets/images/treatments/hydra_facial_care.jpg';
    case 'treatment_pore':
      return 'assets/images/treatments/deep_cleansing_facial.jpg';
    case 'treatment_barrier':
      return 'assets/images/treatments/hydra_facial_care.jpg';
    default:
      return _treatmentImageFallback;
  }
}
