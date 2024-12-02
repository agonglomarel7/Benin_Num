import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Configurez selon votre maquette
      builder: ((context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
      )),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      if (await Permission.contacts.request().isGranted) {
        fetchContacts();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission refusée pour accéder aux contacts.')),
        );
      }
    }
  }

  void fetchContacts() async {
    try {
      final fetchedContacts = await ContactsService.getContacts();
      setState(() {
        contacts = fetchedContacts.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur lors du chargement des contacts : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: isLoading
          ?
      const Center(
          child: CircularProgressIndicator())
          : Stack(
            children:
            [
              ListView.builder(

                itemCount: contacts.length,
                itemBuilder: (context, index)
                {
                final contact = contacts[index];
                return ListTile(
                  leading: Container(
                    height: 30.h,
                    width: 30.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.white.withOpacity(0.1),
                          offset: const Offset(-3, -3),
                        ),
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(3, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6.r),
                      color: const Color(0xff262626),
                    ),
                    child: Text(
                      contact.givenName != null && contact.givenName!.isNotEmpty
                          ? contact.givenName![0]
                          : '?',
                      style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.primaries[
                        Random().nextInt(Colors.primaries.length)],
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  title: Text(
                    contact.givenName ?? 'Sans nom',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.cyanAccent,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    contact.phones != null && contact.phones!.isNotEmpty
                        ? contact.phones![0].value ?? 'Aucun numéro'
                        : 'Aucun numéro',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xffC4c4c4),
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  horizontalTitleGap: 12.w,
                );
                    },
              ),
              buildFloatingButtons()
            ],
      )
    );
  }

  Widget buildFloatingButtons() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              // Action pour "Exporter"
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Exporter les contacts...")));
            },
            label: const Text("Exporter"),
            icon: const Icon(Icons.upload),
            backgroundColor: Color(0xffC4c4c4),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              // Action pour "Convertir"
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Convertir les contacts...")));
            },
            label: const Text("Convertir"),
            icon: const Icon(Icons.transform),
            backgroundColor: Color(0xffC4c4c4),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              // Action pour "Restaurer"
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Restaurer les contacts...")));
            },
            label: const Text("Restaurer"),
            icon: const Icon(Icons.restore),
            backgroundColor: Color(0xffC4c4c4),
          ),
        ],
      ),
    );
  }
}
