import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final nameInput = TextEditingController();
  final sectionInput = TextEditingController();
  final courseInput = TextEditingController();

  final subjectOne = TextEditingController();
  final timeOne = TextEditingController();
  final subjectTwo = TextEditingController();
  final timeTwo = TextEditingController();

  final database = FirebaseFirestore.instance;

  int pageIndex = 0;

  @override
  void dispose() {
    nameInput.dispose();
    sectionInput.dispose();
    courseInput.dispose();

    subjectOne.dispose();
    timeOne.dispose();
    subjectTwo.dispose();
    timeTwo.dispose();

    super.dispose();
  }

  bool checkRegistration() {
    return nameInput.text.trim().isNotEmpty &&
        sectionInput.text.trim().isNotEmpty &&
        courseInput.text.trim().isNotEmpty;
  }

  bool checkSubjects() {
    return subjectOne.text.trim().isNotEmpty &&
        timeOne.text.trim().isNotEmpty &&
        subjectTwo.text.trim().isNotEmpty &&
        timeTwo.text.trim().isNotEmpty;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> submitEnrollment() async {
    final subjectData = [
      {
        'subject': subjectOne.text.trim(),
        'time': timeOne.text.trim(),
      },
      {
        'subject': subjectTwo.text.trim(),
        'time': timeTwo.text.trim(),
      },
    ];

    try {
      await database.collection('activity3-57aa7').add({
        'name': nameInput.text.trim(),
        'section': sectionInput.text.trim(),
        'course': courseInput.text.trim(),
        'subjects': subjectData,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage('Enrollment saved successfully!');

      resetForm();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void resetForm() {
    nameInput.clear();
    sectionInput.clear();
    courseInput.clear();

    subjectOne.clear();
    timeOne.clear();
    subjectTwo.clear();
    timeTwo.clear();

    setState(() {
      pageIndex = 0;
    });
  }

  Widget inputBox({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget registrationScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Registration',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          inputBox(
            controller: nameInput,
            label: 'Name',
            hint: 'Enter your name',
          ),

          const SizedBox(height: 16),

          inputBox(
            controller: sectionInput,
            label: 'Section',
            hint: 'Example: IT-305',
          ),

          const SizedBox(height: 16),

          inputBox(
            controller: courseInput,
            label: 'Course',
            hint: 'Example: BSIT',
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!checkRegistration()) {
                  showMessage('Please complete the fields.');
                  return;
                }

                setState(() {
                  pageIndex = 1;
                });
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget subjectScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Enrollment',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          subjectCard(
            number: 1,
            subjectController: subjectOne,
            timeController: timeOne,
          ),

          const SizedBox(height: 15),

          subjectCard(
            number: 2,
            subjectController: subjectTwo,
            timeController: timeTwo,
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: const Text('Back'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!checkSubjects()) {
                      showMessage('Please complete all subjects.');
                      return;
                    }

                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget subjectCard({
    required int number,
    required TextEditingController subjectController,
    required TextEditingController timeController,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject $number',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            inputBox(
              controller: subjectController,
              label: 'Subject',
              hint: 'Example: BMC',
            ),

            const SizedBox(height: 12),

            inputBox(
              controller: timeController,
              label: 'Time',
              hint: 'Example: 7:30 - 10:30',
            ),
          ],
        ),
      ),
    );
  }

  Widget verificationScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subject Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          detailItem('Name', nameInput.text),
          detailItem('Section', sectionInput.text),
          detailItem('Course', courseInput.text),

          const SizedBox(height: 20),

          const Text(
            'Subjects',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          verificationCard(
            number: 1,
            subject: subjectOne.text,
            time: timeOne.text,
          ),

          verificationCard(
            number: 2,
            subject: subjectTwo.text,
            time: timeTwo.text,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: const Text('Back'),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: submitEnrollment,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget verificationCard({
    required int number,
    required String subject,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject $number',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(subject),

            const SizedBox(height: 5),

            Text('Time: $time'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Enrollment'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: pageIndex == 0
            ? registrationScreen()
            : pageIndex == 1
                ? subjectScreen()
                : verificationScreen(),
      ),
    );
  }
}