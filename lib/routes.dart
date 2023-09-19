import 'package:MyMedTrip/bindings/ConsultationBinding.dart';
import 'package:MyMedTrip/bindings/HospitalBinding.dart';
import 'package:MyMedTrip/bindings/UserBinding.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/screens/Hospitals/hospital_details_screen.dart';
import 'package:MyMedTrip/screens/doctor/doctor_details_new.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:MyMedTrip/bindings/AuthBinding.dart';
import 'package:MyMedTrip/bindings/DoctorBinding.dart';
import 'package:MyMedTrip/bindings/InitialBinding.dart';
import 'package:MyMedTrip/bindings/QueryBinding.dart';
import 'package:MyMedTrip/screens/Home_screens/faqs.dart';
import 'package:MyMedTrip/screens/Home_screens/home_bottom.dart';
import 'package:MyMedTrip/screens/Hospitals/availble_treatment.dart';
import 'package:MyMedTrip/screens/Hospitals/doctors_details.dart';
import 'package:MyMedTrip/screens/Hospitals/doctors_list.dart';
import 'package:MyMedTrip/screens/Hospitals/hospitals_list_page.dart';
import 'package:MyMedTrip/screens/Hospitals/patient_stories.dart';
import 'package:MyMedTrip/screens/Query/generate_new_query.dart';
import 'package:MyMedTrip/screens/Query/query.dart';
import 'package:MyMedTrip/screens/Settings_page/add_family.dart';
import 'package:MyMedTrip/screens/Settings_page/add_family_list.dart';
import 'package:MyMedTrip/screens/Settings_page/medical_edit.dart';
import 'package:MyMedTrip/screens/Settings_page/profile_edit.dart';
import 'package:MyMedTrip/screens/Settings_page/profile_page.dart';
import 'package:MyMedTrip/screens/Settings_page/settings.dart';
import 'package:MyMedTrip/screens/Video_consult/doctor_call.dart';
import 'package:MyMedTrip/screens/Video_consult/shedule.dart';
import 'package:MyMedTrip/screens/Video_consult/teleconsult.dart';
import 'package:MyMedTrip/screens/Video_consult/thankyou.dart';
import 'package:MyMedTrip/screens/connects/connect_homepage.dart';
import 'package:MyMedTrip/screens/connects/messages_page.dart';
import 'package:MyMedTrip/screens/connects/support_connect.dart';
import 'package:MyMedTrip/screens/connects/video_call_screen.dart';
import 'package:MyMedTrip/screens/login/complete_signup.dart';
import 'package:MyMedTrip/screens/Settings_page/help_page.dart';
import 'package:MyMedTrip/screens/login/language_page.dart';
import 'package:MyMedTrip/screens/login/login_fingerprint.dart';
import 'package:MyMedTrip/screens/auth/login.dart';
import 'package:MyMedTrip/screens/login/sing_up.dart';
import 'package:MyMedTrip/screens/login/verify.dart';
import 'package:MyMedTrip/screens/trending_blogs/read_blog.dart';
import 'package:MyMedTrip/screens/trending_blogs/trending_blog.dart';
import 'package:MyMedTrip/screens/update_screen/connect_coordinotor.dart';
import 'package:MyMedTrip/screens/update_screen/query_confirmed.dart';

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
  static String doctorPreviewNew = '/doctor_preview_new';
  static String teleconsultationSchedule = '/teleconsultation_schedule';
  static String teleconsultationPay = '/teleconsultation_pay';
  static String teleconsultationConfirm = '/teleconsultation_confirm';
  static String teleconsultationConnect = '/teleconsultation_connect';
  static String videoChat = '/video_chat';
  static String supportCall = '/support_call';
  static String supportChat = '/support_chat';
}

final getPages = [
  GetPage(
    name: Routes.languageSelector,
    page: () => const Language_page(),
  ),
  GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      bindings: [AuthBinding(), InitialBinding()]),
  GetPage(name: Routes.registerFirstStep, page: () => const SignupHerePage()),
  GetPage(
      name: Routes.registerSecondStep,
      page: () => const Complete_Sign_Up_Page()),
  GetPage(name: Routes.otpVerify, page: () => const Verify_page()),
  GetPage(name: Routes.profile, page: () => const Profile_Page()),
  GetPage(name: Routes.biometric, page: () => const Login_fingerprint_page()),
  GetPage(name: Routes.home, page: () => const Home_screen(), bindings: [
    QueryBinding(),
  ]),
  GetPage(name: Routes.faq, page: () => const FAQS_Page()),
  GetPage(name: Routes.setting, page: () => const User_Profile()),
  GetPage(name: Routes.addPersonalDetail, page: () => Profile_edit_page()),
  GetPage(name: Routes.addMedicalDetail, page: () => const Medical_Edit_page()),
  GetPage(name: Routes.support, page: () => const Need_Help_page()),
  GetPage(name: Routes.addFamily, page: () => const Add_family_page()),
  GetPage(name: Routes.listFamily, page: () => const Add_Family_List_page()),
  GetPage(name: Routes.listQuery, page: () => const Query_page()),
  GetPage(
    name: Routes.startQuery,
    page: () => const Generate_New_Query(),
    binding: QueryBinding(),
  ),
  GetPage(name: Routes.confirmedQuery, page: () => QueryConfirmed()),
  GetPage(name: Routes.noCoordinator, page: () => const NoCoordinator()),
  GetPage(
    name: Routes.connects,
    page: () => const Connect_Home_page(),
    binding: ConsultationBinding(),
  ),
  GetPage(name: Routes.chat, page: () => const Messages_pages()),
  GetPage(name: Routes.blogs, page: () => const TrendingBlogs()),
  // GetPage(
  //     name: Routes.blogDetails,
  //     page: () => ReadBlogPage("title", "description")
  // ),
  GetPage(
    name: Routes.hospitals,
    page: () => const HospitalsListPage(),
    binding: HospitalBinding(),
  ),
  GetPage(
    name: Routes.hospitalPreview,
    page: () => const HospitalDetailsScreen(),
    // binding: HospitalBinding(),
  ),
  GetPage(
      name: Routes.treatmentsAvailable,
      page: () => const Available_Treatment()),
  GetPage(name: Routes.patientTestimony, page: () => const Patient_page()),
  GetPage(
    name: Routes.doctors,
    page: () => const Doctors_list_page(),
    binding: DoctorBinding(),
  ),
  GetPage(
    name: Routes.doctorPreview,
    page: () => const Doctors_Details_page(),
    binding: DoctorBinding(),
  ),
  GetPage(
    name: Routes.doctorPreviewNew,
    page: () => DoctorDetailScreen(),
  ),
  GetPage(
      name: Routes.teleconsultationSchedule,
      page: () => const TeLe_Consult_page()),
  GetPage(name: Routes.teleconsultationPay, page: () => const Schedule_page()),
  GetPage(
      name: Routes.teleconsultationConfirm, page: () => const Thank_you_page()),
  GetPage(
      name: Routes.teleconsultationConnect,
      page: () => const Doctor_call_page()),
  GetPage(name: Routes.videoChat, page: () => const Video_Call_Screen()),
  GetPage(name: Routes.supportCall, page: () => const SupportConnect(), binding: UserBinding()),
];
