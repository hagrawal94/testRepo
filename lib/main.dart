import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocDir = await getApplicationDocumentsDirectory();
  Hive.init('${appDocDir.path}/db');
  await Hive.openBox('prefs');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isValidEntry = true;
  Box box = Hive.box('prefs');

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Welcome to test',
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        label: Text('Email'),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value ?? '')) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        label: Text('Mobile'),
                      ),
                      controller: phoneController,
                      validator: (value) {
                        if (!(value != null && value.length == 10)) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!box.keys.toList().contains(emailController.text) &&
                            !box.values
                                .toList()
                                .contains(phoneController.text)) {
                          setState(() {
                            isValidEntry = true;
                          });
                          box.put(emailController.text, phoneController.text);
                        } else {
                          setState(() {
                            isValidEntry = false;
                          });
                        }
                      },
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: Text('Add Entry')),
                      ),
                    ),
                    if (!isValidEntry)
                      const Text(
                        'Duplicate email or phone number',
                        style: TextStyle(color: Colors.red),
                      )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('Entries'),
                    const SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(box.keys.toList()[index]),
                              Text(box.values.toList()[index]),
                            ]);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
