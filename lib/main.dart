import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurpleAccent,
            titleTextStyle: TextStyle(color: Colors.white)),
      ),
      home: const BMICalculator(title: 'BMI Calculator'),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key, required this.title});

  final String title;

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  // ประกาศตัวแปรแบบ static สำหรับรเพศและเกณฑ์ BMI
  static List<String> gender = <String>['ผู้ชาย', 'ผู้หญิง'];
  static List criteriaBMI = [18.5, 25, 30, 35, 40];

  // กำหนดค่าเริ่มต้นของตัวแปร
  String genderValue = gender[0];
  double height = 160.0;
  double weight = 50.0;
  double bmi = 0.0;
  String bmiResult = "";
  String bmiInfo = "";

  // ข้อมูล BMI ตามเกณฑ์ที่กำหนด
  static var bmiMsg = {
    "ผอมเกินไป":
        "น้ำหนักน้อยกว่าปกติก็ไม่ค่อยดี หากคุณสูงมากแต่น้ำหนักน้อยเกินไป อาจเสี่ยงต่อการได้รับสารอาหารไม่เพียงพอหรือได้รับพลังงานไม่เพียงพอ ส่งผลให้ร่างกายอ่อนเพลียง่าย การรับประทานอาหารให้เพียงพอ และการออกกำลังกายเพื่อเสริมสร้างกล้ามเนื้อสามารถช่วยเพิ่มค่า BMI ให้อยู่ในเกณฑ์ปกติได้",
    "น้ำหนักปกติ":
        "น้ำหนักที่เหมาะสมสำหรับคนไทยคือค่า BMI ระหว่าง 18.5-24 จัดอยู่ในเกณฑ์ปกติ ห่างไกลโรคที่เกิดจากความอ้วน และมีความเสี่ยงต่อการเกิดโรคต่าง ๆ น้อยที่สุด ควรพยายามรักษาระดับค่า BMI ให้อยู่ในระดับนี้ให้นานที่สุด และควรตรวจสุขภาพทุกปี",
    "ท้วม":
        "อ้วนในระดับหนึ่ง ถึงแม้จะไม่ถึงเกณฑ์ที่ถือว่าอ้วนมาก ๆ แต่ก็ยังมีความเสี่ยงต่อการเกิดโรคที่มากับความอ้วนได้เช่นกัน ทั้งโรคเบาหวาน และความดันโลหิตสูง ควรปรับพฤติกรรมการทานอาหาร ออกกำลังกาย และตรวจสุขภาพ",
    "โรคอ้วนระดับ 1":
        "ค่อนข้างอันตราย เสี่ยงต่อการเกิดโรคร้ายแรงที่แฝงมากับความอ้วน หากค่า BMI อยู่ในระดับนี้ จะต้องปรับพฤติกรรมการทานอาหาร และควรเริ่มออกกำลังกาย ตรวจสุขภาพ และปรึกษาแพทย์",
    "โรคอ้วนระดับ 2":
        "อยู่ในระดับที่เสี่ยงมากและเข้าสู่เกณฑ์อันตราย ควรทำการปรับพฤติกรรมการทานอาหารและเพิ่มกิจกรรมทางกาย เพื่อลดน้ำหนัก เช่นการลดปริมาณอาหารที่รับประทานและเพิ่มการออกกำลังกายอย่างสม่ำเสมอ",
    "โรคอ้วนระดับ 3":
        "อยู่ในระดับที่เสี่ยงอันตรายมาก ควรพบแพทย์เพื่อการประเมินและแนะนำการรักษาที่เหมาะสม ต้องปรับเปลี่ยนพฤติกรรมทานอาหารและเพิ่มกิจกรรมทางกายอย่างเร่งด่วน เนื่องจากมีความเสี่ยงสูงต่อการเกิดโรคร้ายแรงต่าง ๆ"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงรูปภาพ BMI
            Container(
              margin: const EdgeInsets.only(
                  bottom: 20), // กำหนดระยะห่างด้านล่างของรูปภาพ
              child: Image.network(
                'https://png.pngtree.com/png-clipart/20230922/original/pngtree-bmi-cartoon-vector-illustration-depicting-medical-concept-unhealthy-vector-body-vector-png-image_12724237.png',
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            // Dropdown เพศ
            DropdownMenu<String>(
              enableSearch: false,
              enableFilter: false,
              initialSelection: gender.first,
              onSelected: (String? value) {
                setState(() {
                  genderValue = value!;
                });
              },
              dropdownMenuEntries:
                  gender.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'ส่วนสูง: ${height.toStringAsFixed(0)} cm',
              style: const TextStyle(fontSize: 16),
            ),
            // แสดงส่วนสูงด้วย Slider
            Slider(
              value: height,
              min: 100,
              max: 220,
              divisions: 220 - 100,
              label: height.round().toString(),
              onChanged: (value) {
                setState(() {
                  height = value;
                });
              },
            ),
            // แสดงน้ำหนักด้วย Slider
            Text(
              'น้ำหนัก: ${weight.toStringAsFixed(0)} kg',
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: weight,
              min: 30,
              max: 150,
              divisions: 150 - 30,
              label: weight.round().toString(),
              onChanged: (value) {
                setState(() {
                  weight = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  EdgeInsets.fromLTRB(80, 20, 80, 20),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Color.fromRGBO(37, 37, 37, 1)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: const Text(
                'คำนวณ BMI',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // แสดงผลลัพธ์ BMI
            Text(
              'BMI: ${bmi.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              bmiResult,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              bmiInfo,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันคำนวณ BMI
  void calculateBMI() {
    double heightInMeters = height / 100;
    setState(() {
      // คำนวณ BMI = น้ำหนัก / (ส่วนสูง * ส่วนสูง)
      bmi = double.parse(
          (weight / (heightInMeters * heightInMeters)).toStringAsFixed(2));

      // หาค่า Index BMI ใน criteriaBMI
      int? bmiIndex = criteriaBMI.indexWhere(
          (a) => bmi < (genderValue == "ผู้หญิง" && a == 25 ? a - 1 : a));
      bmiIndex = bmiIndex == -1 ? criteriaBMI.length : bmiIndex;

      bmiResult = bmiMsg.keys.elementAt(bmiIndex);
      bmiInfo = bmiMsg.values.elementAt(bmiIndex);
    });
  }
}
