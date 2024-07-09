import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contact_list_screen.dart';
import 'main.dart';
import 'my_home_page.dart';
import 'theme_provider.dart';
import 'app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Uint8List? _profileImageBytes;
  Iterable<Contact> _contacts = [];

  static final List<Widget> _widgetOptions = <Widget>[
    const MyHomePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('contacts_permission_title') ?? 'Permission Required'),
          content: Text(AppLocalizations.of(context)!.translate('contacts_permission_message') ?? 'This app needs contact permissions to function.'),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('ok') ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/signin');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/signup');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _profileImageBytes = bytes;
        });
      } else {
        setState(() {
          _profileImageBytes = File(image.path).readAsBytesSync();
        });
      }
    }
  }

  void _switchLanguage(String languageCode) async {
    Locale _temp = Locale(languageCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('title') ?? 'App Title'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Switch(
            value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).setTheme(
                value ? ThemeMode.dark : ThemeMode.light,
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.translate('home') ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: AppLocalizations.of(context)!.translate('signIn') ?? 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: AppLocalizations.of(context)!.translate('signUp') ?? 'Sign Up',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageBytes != null
                        ? MemoryImage(_profileImageBytes!)
                        : AssetImage('assets/default_profile.jpg') as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.translate('profile') ?? 'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text(AppLocalizations.of(context)!.translate('contacts') ?? 'Contacts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactListScreen(contacts: _contacts)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(AppLocalizations.of(context)!.translate('editProfile') ?? 'Edit Profile'),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text(AppLocalizations.of(context)!.translate('camera') ?? 'Camera'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.camera);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_album),
                          title: Text(AppLocalizations.of(context)!.translate('gallery') ?? 'Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('English'),
              onTap: () {
                _switchLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Français'),
              onTap: () {
                _switchLanguage('fr');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
