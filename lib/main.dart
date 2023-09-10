import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  String? passwordError, emailError;
  bool isPasswordTapped = false, isEmailTapped = false, isNotVisible = true;
  late final SharedPreferences prefs;

  @override
  void initState() {
    passwordController.addListener(() {
      if (passwordController.text.length == 1 && !isPasswordTapped) {
        setState(() {
          isPasswordTapped = true;
        });
      }
      if (!isPasswordTapped) return;

      // password must have at least 1 capital letter
      if (!passwordController.text.contains(RegExp(r'[A-Z]'))) {
        passwordError = 'Password harus memiliki 1 huruf kapital';
        setState(() {});
        return;
      }
      passwordError = passwordController.text.length < 8
          ? 'Password harus lebih dari 8 karakter'
          : null;
      setState(() {});
    });
    emailController.addListener(() {
      if (emailController.text.length == 1 && !isEmailTapped) {
        setState(() {
          isEmailTapped = true;
        });
      }
      if (!isEmailTapped) return;
      emailError = !emailController.text
              .contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))
          ? 'Email tidak valid'
          : null;
      setState(() {});
    });
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      if (prefs.containsKey('email')) {
        emailController.text = prefs.getString('email')!;
      }
      if (prefs.containsKey('isLoggedIn') && prefs.getBool('isLoggedIn')!) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const KelasKu(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.shade200,
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.teal.shade200,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: double.infinity,
                        child: Image.network(
                          'https://th.bing.com/th/id/OIP.dUVsyrfd6wG6agPuA5FjcwHaEK?pid=ImgDet&rs=1',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.shade200,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Masuk dan',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Mulailah Belajar',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            errorText: emailError,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: isNotVisible,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            errorText: passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isNotVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.blue.shade900,
                              ),
                              onPressed: () {
                                setState(() {
                                  isNotVisible = !isNotVisible;
                                });
                              },
                            ),
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.blue.shade900),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final String? registeredEmail =
                                    prefs.getString('email');
                                final String? registeredPassword =
                                    prefs.getString('password');
                                if (registeredEmail == null ||
                                    registeredPassword == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Anda belum mendaftar, silahkan daftar terlebih dahulu',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (emailController.text != registeredEmail ||
                                    passwordController.text !=
                                        registeredPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Email atau password salah'),
                                    ),
                                  );
                                  return;
                                }
                                prefs.setBool('isLoggedIn', true);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const KelasKu(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return Dialog(
                                        child: DialogRegister(prefs: prefs),
                                      );
                                    });
                              },
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class DialogRegister extends StatefulWidget {
  const DialogRegister({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  State<DialogRegister> createState() => _DialogRegisterState();
}

class _DialogRegisterState extends State<DialogRegister> {
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Daftar'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.prefs.setString('email', emailController.text);
                widget.prefs.setString('password', passwordController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil Mendaftar'),
                  ),
                );
              },
              child: const Text('Daftar'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class KelasKu extends StatefulWidget {
  const KelasKu({super.key});

  @override
  State<KelasKu> createState() => _KelasKuState();
}

class _KelasKuState extends State<KelasKu> {
  int selectedIndex = 1;
  List<IconData> icons = [
    Icons.home,
    Icons.calendar_month,
    Icons.notifications,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kelasku',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showMenu(
                            context: context,
                            position: const RelativeRect.fromLTRB(
                              100,
                              100,
                              0,
                              0,
                            ),
                            items: [
                              PopupMenuItem(
                                child: const Text('Logout'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => const MyHomePage(),
                                  //   ),
                                  // );
                                  await SharedPreferences.getInstance()
                                      .then((value) {
                                    value.setBool('isLoggedIn', false);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://th.bing.com/th/id/OIP.dUVsyrfd6wG6agPuA5FjcwHaEK?pid=ImgDet&rs=1',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Text(
                    'Selamat Datang Hugo',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const KelasCard(
                    namaKelas: 'Praktikum PCD',
                    namaGuru: 'Puja Hanifah',
                    color: Colors.teal,
                  ),
                  const KelasCard(
                    namaKelas: 'Bengkel GIS',
                    namaGuru: 'Iqbal Mahatma',
                    color: Colors.red,
                  ),
                  const KelasCard(
                    namaKelas: 'Animasi Komputer',
                    namaGuru: 'Aida Kamila',
                    color: Colors.indigo,
                  ),
                  const KelasCard(
                    namaKelas: 'AKJK',
                    namaGuru: 'Admin',
                    color: Colors.orange,
                  ),
                  const KelasCard(
                    namaKelas: 'Praktikum PCD',
                    namaGuru: 'Puja Hanifah',
                    color: Colors.yellow,
                  ),
                  const KelasCard(
                    namaKelas: 'Praktikum PCD',
                    namaGuru: 'Puja Hanifah',
                    color: Colors.red,
                  ),
                  const KelasCard(
                    namaKelas: 'Praktikum PCD',
                    namaGuru: 'Puja Hanifah',
                    color: Colors.blue,
                  ),
                ],
              ),
              Container(
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < icons.length; i++)
                        IconKelas(
                          icon: icons[i],
                          selected: i == selectedIndex,
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
                            });
                          },
                        ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class IconKelas extends StatelessWidget {
  const IconKelas({
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Transform.translate(
        offset: const Offset(0, -30),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade900,
          child: Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: Colors.grey.shade700,
        ),
      );
    }
  }
}

class KelasCard extends StatelessWidget {
  const KelasCard({
    required this.namaKelas,
    required this.namaGuru,
    required this.color,
    super.key,
  });
  final String namaKelas, namaGuru;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: color.shade100,
          ),
          height: 150,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            children: [
              Container(
                color: color.shade200,
                width: 12,
                height: double.maxFinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListTile(
                        title: Text(
                          namaKelas,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: const Text('Tahun ajaran 2019/2020'),
                        trailing: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.notifications,
                            size: 15,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://th.bing.com/th/id/OIP.dUVsyrfd6wG6agPuA5FjcwHaEK?pid=ImgDet&rs=1',
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(namaGuru)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
