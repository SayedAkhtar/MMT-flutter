import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mmt_/bindings/AuthBinding.dart';
import 'package:mmt_/bindings/DoctorBinding.dart';
import 'package:mmt_/bindings/HospitalBinding.dart';
import 'package:mmt_/bindings/QueryBinding.dart';
import 'package:mmt_/screens/Home_screens/faqs.dart';
import 'package:mmt_/screens/Home_screens/home_bottom.dart';
import 'package:mmt_/screens/Hospitals/availble_treatment.dart';
import 'package:mmt_/screens/Hospitals/doctors_details.dart';
import 'package:mmt_/screens/Hospitals/doctors_list.dart';
import 'package:mmt_/screens/Hospitals/hospital_preview.dart';
import 'package:mmt_/screens/Hospitals/hospitals_page.dart';
import 'package:mmt_/screens/Hospitals/patient_stories.dart';
import 'package:mmt_/screens/Medical_visa/doctor_reply.dart';
import 'package:mmt_/screens/Medical_visa/document_preview.dart';
import 'package:mmt_/screens/Medical_visa/document_visa.dart';
import 'package:mmt_/screens/Medical_visa/pay_page.dart';
import 'package:mmt_/screens/Medical_visa/processing_page.dart';
import 'package:mmt_/screens/Medical_visa/terms_and_conditions.dart';
import 'package:mmt_/screens/Medical_visa/upload_ticket_visa.dart';
import 'package:mmt_/screens/Medical_visa/visa_end_page.dart';
import 'package:mmt_/screens/Query/generate_new_query.dart';
import 'package:mmt_/screens/Query/query.dart';
import 'package:mmt_/screens/Settings_page/add_family.dart';
import 'package:mmt_/screens/Settings_page/add_family_list.dart';
import 'package:mmt_/screens/Settings_page/medical_edit.dart';
import 'package:mmt_/screens/Settings_page/profile_edit.dart';
import 'package:mmt_/screens/Settings_page/profile_page.dart';
import 'package:mmt_/screens/Settings_page/settings.dart';
import 'package:mmt_/screens/Video_consult/doctor_call.dart';
import 'package:mmt_/screens/Video_consult/shedule.dart';
import 'package:mmt_/screens/Video_consult/teleconsult.dart';
import 'package:mmt_/screens/Video_consult/thankyou.dart';
import 'package:mmt_/screens/connects/connect_homepage.dart';
import 'package:mmt_/screens/connects/messages_page.dart';
import 'package:mmt_/screens/connects/video_call_screen.dart';
import 'package:mmt_/screens/login/complete_signup.dart';
import 'package:mmt_/screens/login/help_page.dart';
import 'package:mmt_/screens/login/language_page.dart';
import 'package:mmt_/screens/login/login_fingerprint.dart';
import 'package:mmt_/screens/auth/login.dart';
import 'package:mmt_/screens/login/sing_up.dart';
import 'package:mmt_/screens/login/verify.dart';
import 'package:mmt_/screens/trending_blogs/read_blog.dart';
import 'package:mmt_/screens/trending_blogs/trending_blog.dart';
import 'package:mmt_/screens/update_screen/connect_coordinotor.dart';
import 'package:mmt_/screens/update_screen/query_confirmed.dart';

class Routes {
  static String languageSelector = '/language_selector';
  static String login = '/login';
  static String registerFirstStep = '/register_first_step';
  static String registerSecondStep = '/register';
  static String otpVerify = '/otp_verify';
  static String biometric = '/biometric';
  static String home = '/home';
  static String faq = '/faq';
  static String setting = '/setting';
  static String profile = '/profile';
  static String addPersonalDetail = '/add_personal_detail';
  static String addMedicalDetail = '/add_medical_detail';
  static String support = '/support';
  static String addFamily = '/add_family';
  static String listFamily = '/list_family';
  static String listQuery = '/list_query';
  static String startQuery = '/start_query';
  static String activeQueryDoctorReply = '/active_query_doctor_reply';
  static String activeQueryProcessing = '/active_query_processing';
  static String activeQueryTermsConditions = '/active_query_terms_conditions';
  static String activeQueryUploadVisa = '/active_query_upload_visa';
  static String activeQueryVisaPreview = '/active_query_visa_preview';
  static String activeQueryPaymentScreen = '/active_query_payment_screen';
  static String activeQueryUploadTicket = '/active_query_upload_ticket';
  static String activeQueryThankYou = '/active_query_thank_you';
  static String confirmedQuery = '/confirmed_query';
  static String noCoordinator = '/no_coordinator';
  static String connects = '/connects';
  static String chat = '/chat';
  static String blogs = '/blogs';
  static String blogDetails = '/blog_details';
  static String hospitals = '/hospitals';
  static String hospitalPreview = '/hospital_preview';
  static String treatmentsAvailable = '/treatments_available';
  static String patientTestimony = '/patient_testimony';
  static String doctors = '/doctors';
  static String doctorPreview = '/doctor_preview';
  static String teleconsultationSchedule = '/teleconsultation_schedule';
  static String teleconsultationPay = '/teleconsultation_pay';
  static String teleconsultationConfirm = '/teleconsultation_confirm';
  static String teleconsultationConnect = '/teleconsultation_connect';
  static String videoChat = '/video_chat';

}

final getPages = [
  GetPage(
    name: Routes.languageSelector,
    page: () => const Language_page(),
  ),
  GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: AuthBinding()
  ),
  GetPage(
      name: Routes.registerFirstStep,
      page: () => const Singup_here_page()
  ),
  GetPage(
      name: Routes.registerSecondStep,
      page: () => const Complete_Sign_Up_Page()
  ),
  GetPage(
      name: Routes.otpVerify,
      page: () => const Verify_page()
  ),
  GetPage(
      name: Routes.profile,
      page: () => const Profile_Page()
  ),
  GetPage(
      name: Routes.biometric,
      page: () => const Login_fingerprint_page()
  ),
  GetPage(
      name: Routes.home,
      page: () => const Home_screen(),
      bindings: [
        QueryBinding(),
      ]
  ),
  GetPage(
      name: Routes.faq,
      page: () => const FAQS_Page()
  ),
  GetPage(
      name: Routes.setting,
      page: () => const User_Profile()
  ),
  GetPage(
      name: Routes.addPersonalDetail,
      page: () => Profile_edit_page()
  ),
  GetPage(
      name: Routes.addMedicalDetail,
      page: () => const Medical_Edit_page()
  ),
  GetPage(
      name: Routes.support,
      page: () => const Need_Help_page()
  ),
  GetPage(
      name: Routes.addFamily,
      page: () => const Add_family_page()
  ),
  GetPage(
      name: Routes.listFamily,
      page: () => const Add_Family_List_page()
  ),
  GetPage(
      name: Routes.listQuery,
      page: () => const Query_page()
  ),
  GetPage(
      name: Routes.startQuery,
      page: () => const Generate_New_Query(),
      binding: QueryBinding(),
  ),
  GetPage(
      name: Routes.activeQueryDoctorReply,
      page: () => DoctorReply()
  ),
  GetPage(
      name: Routes.activeQueryProcessing,
      page: () => const Proccessing_page()
  ),
  GetPage(
      name: Routes.activeQueryTermsConditions,
      page: () => const Terms_and_Conditions()
  ),
  GetPage(
      name: Routes.activeQueryUploadVisa,
      page: () => const Document_visa_page()
  ),
  GetPage(
      name: Routes.activeQueryVisaPreview,
      page: () => const Document_preview_page()
  ),
  GetPage(
      name: Routes.activeQueryPaymentScreen,
      page: () => const Pay_page()
  ),
  GetPage(
      name: Routes.activeQueryUploadTicket,
      page: () => const Upload_Ticket_visa()
  ),
  GetPage(
      name: Routes.activeQueryThankYou,
      page: () => const Visa_submit_page()
  ),
  GetPage(
      name: Routes.confirmedQuery,
      page: () => QueryConfirmed()
  ),
  GetPage(
      name: Routes.noCoordinator,
      page: () => const NoCoordinator()
  ),
  GetPage(
      name: Routes.connects,
      page: () => const Connect_Home_page()
  ),
  GetPage(
      name: Routes.chat,
      page: () => const Messages_pages()
  ),
  GetPage(
      name: Routes.blogs,
      page: () => const Trending_blog_page()
  ),
  // GetPage(
  //     name: Routes.blogDetails,
  //     page: () => ReadBlogPage("title", "description")
  // ),
  GetPage(
      name: Routes.hospitals,
      page: () => const Hospitals_page()
  ),
  GetPage(
      name: Routes.hospitalPreview,
      page: () => const Hospital_preview_page(),
      binding: HospitalBinding(),

  ),
  GetPage(
      name: Routes.treatmentsAvailable,
      page: () => const Available_Treatment()
  ),
  GetPage(
      name: Routes.patientTestimony,
      page: () => const Patient_page()
  ),
  GetPage(
      name: Routes.doctors,
      page: () => const Doctors_list_page(),
      binding: DoctorBinding(),
  ),
  GetPage(
      name: Routes.doctorPreview,
      page: () => const Doctors_Details_page(),
  ),
  GetPage(
      name: Routes.teleconsultationSchedule,
      page: () => const TeLe_Consult_page()
  ),
  GetPage(
      name: Routes.teleconsultationPay,
      page: () => const Schedule_page()
  ),
  GetPage(
      name: Routes.teleconsultationConfirm,
      page: () => const Thank_you_page()
  ),
  GetPage(
      name: Routes.teleconsultationConnect,
      page: () => const Doctor_call_page()
  ),
  GetPage(
      name: Routes.videoChat,
      page: () => const Video_Call_Screen()
  ),
];

