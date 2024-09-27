import 'package:bars/features/creatives/models/timstamp_adapter.dart';
import 'package:bars/utilities/exports.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> initializeApp() async {
  try {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();
  } catch (e) {}
}

Future<void> _backgroundHandler(message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(SendContentMessageAdapter());
  Hive.registerAdapter(ReplyToMessageAdapter());
  Hive.registerAdapter(MessageAttachmentAdapter());
  Hive.registerAdapter(TimestampAdapter());
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(EventRoomAdapter());
  Hive.registerAdapter(TicketIdModelAdapter());
  Hive.registerAdapter(AccountHolderAuthorAdapter());
  Hive.registerAdapter(UserSettingsLoadingPreferenceModelAdapter());
  Hive.registerAdapter(UserStoreModelAdapter());
  Hive.registerAdapter(PortfolioModelAdapter());
  Hive.registerAdapter(PriceModelAdapter());
    Hive.registerAdapter(PortfolioContactModelAdapter());


  await Hive.openBox<ChatMessage>('chatMessages');
  await Hive.openBox<Chat>('chats');
  await Hive.openBox<EventRoom>('eventRooms');
  await Hive.openBox<TicketIdModel>('ticketIds');
  await Hive.openBox<AccountHolderAuthor>('accountHolderAuthor');
  await Hive.openBox<AccountHolderAuthor>('currentUser');
  await Hive.openBox<UserStoreModel>('accountUserStore');

  await Hive.openBox<UserSettingsLoadingPreferenceModel>(
      'accountLocationPreference');
  runApp(ConfigPage());
}
