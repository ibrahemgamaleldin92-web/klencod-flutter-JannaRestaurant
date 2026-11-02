
import 'package:flutter/material.dart';

void main() {
  runApp(const JannaApp());
}

const Color green = Color(0xFF0B1913);
const Color surface = Color(0xFF17291F);
const Color gold = Color(0xFFE4C47D);
const Color cream = Color(0xFFF7F5EF);

class JannaApp extends StatelessWidget {
  const JannaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'جنة المحلة',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  String name;
  double price;
  String category;
  bool available;

  Product({
    required this.name,
    required this.price,
    required this.category,
    this.available = true,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> products = [
    Product(name: 'برجر كلاسيك', price: 100, category: 'برجر'),
    Product(name: 'بيتزا مارجريتا', price: 120, category: 'بيتزا'),
    Product(name: 'وجبة فراخ', price: 150, category: 'وجبات'),
    Product(name: 'مشروب بارد', price: 25, category: 'مشروبات'),
  ];

  final List<Product> cart = [];

  int selectedTab = 0;

  void addToCart(Product product) {
    setState(() => cart.add(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${product.name} للسلة'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void openAdmin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminPage(products: products),
      ),
    ).then((_) => setState(() {}));
  }

  void showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double total = cart.fold(
          0,
          (sum, item) => sum + item.price,
        );

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'سلة المشتريات',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              if (cart.isEmpty)
                const Text('السلة فارغة')
              else
                ...cart.map(
                  (item) => ListTile(
                    title: Text(item.name),
                    trailing: Text('${item.price} ج'),
                  ),
                ),
              const Divider(),
              Text(
                'الإجمالي: $total جنيه',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'سيتم تفعيل إرسال الطلبات بعد ربط قاعدة البيانات',
                              ),
                            ),
                          );
                        },
                  child: const Text('تأكيد الطلب'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: gold,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'جنة المحلة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'JANNA RESTAURANT & CAFE',
              style: TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: openAdmin,
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'الإدارة',
          ),
        ],
      ),
      body: selectedTab == 0
          ? customerPage()
          : Center(
              child: TextButton(
                onPressed: openAdmin,
                child: const Text('دخول الإدارة'),
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'المنيو',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: green,
        foregroundColor: gold,
        onPressed: showCart,
        icon: const Icon(Icons.shopping_cart),
        label: Text('السلة (${cart.length})'),
      ),
    );
  }

  Widget customerPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 190,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أهلاً بك في جنة المحلة',
                style: TextStyle(
                  color: gold,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'طعم مميز وتجربة تستحق التكرار',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),
              Text(
                'اطلب أكلك المفضل الآن',
                style: TextStyle(color: gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          'اكتشف المنيو',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: green,
          ),
        ),
        const SizedBox(height: 15),
        ...products.where((p) => p.available).map(
          (product) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8D8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fastfood,
                  color: green,
                  size: 30,
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${product.price} جنيه'),
              trailing: IconButton(
                onPressed: () => addToCart(product),
                icon: const Icon(
                  Icons.add_circle,
                  color: green,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AdminPage extends StatefulWidget {
  final List<Product> products;

  const AdminPage({super.key, required this.products});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool loggedIn = false;

  void addProduct() {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text);

    if (name.isEmpty || price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل اسم المنتج والسعر بشكل صحيح')),
      );
      return;
    }

    setState(() {
      widget.products.add(
        Product(
          name: name,
          price: price,
          category: 'عام',
        ),
      );
    });

    nameController.clear();
    priceController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة المنتج')),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!loggedIn) {
      return Scaffold(
        backgroundColor: green,
        appBar: AppBar(
          backgroundColor: green,
          foregroundColor: gold,
          title: const Text('إدارة جنة المحلة'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.lock, color: gold, size: 65),
                const SizedBox(height: 20),
                const Text(
                  'دخول الإدارة',
                  style: TextStyle(color: gold, fontSize: 27),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    labelStyle: TextStyle(color: gold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: gold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    labelStyle: TextStyle(color: gold),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: gold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تسجيل الدخول الحقيقي لم يتم إعداده بعد',
                        ),
                      ),
                    );
                  },
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: gold,
        title: const Text('لوحة الإدارة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            'إدارة المنتجات',
            style: TextStyle(
              color: green,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'اسم المنتج',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'السعر بالجنيه',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: addProduct,
            child: const Text('إضافة منتج'),
          ),
          const SizedBox(height: 25),
          ...widget.products.asMap().entries.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.value.name),
                subtitle: Text('${entry.value.price} جنيه'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.products.removeAt(entry.key);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}