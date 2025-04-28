import 'package:flutter/material.dart';

class SkinToneDetectionPage extends StatefulWidget {
  const SkinToneDetectionPage({super.key});

  @override
  State<SkinToneDetectionPage> createState() => _SkinToneDetectionPageState();
}

class _SkinToneDetectionPageState extends State<SkinToneDetectionPage> {
  // Selected skin tone (could be set from camera/upload)
  String? selectedTone;
  bool isAnalyzing = false;

  // Sample skin tone categories
  final List<Map<String, dynamic>> skinTones = [
    {
      'name': 'Fair',
      'color': const Color(0xFFFFDFCB),
      'description': 'Pale or fair skin that burns easily',
    },
    {
      'name': 'Light',
      'color': const Color(0xFFF1C27D),
      'description': 'Light skin that sometimes tans',
    },
    {
      'name': 'Medium',
      'color': const Color(0xFFE0AC69),
      'description': 'Medium skin that tans well',
    },
    {
      'name': 'Olive',
      'color': const Color(0xFFC68642),
      'description': 'Olive or moderate brown skin',
    },
    {
      'name': 'Deep',
      'color': const Color(0xFF8D5524),
      'description': 'Dark brown or black skin',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skin Tone Detection',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFD7CCC8),
        foregroundColor: const Color(0xFF5D4037),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Instructions Card
              _buildInstructionsCard(),
              const SizedBox(height: 25),
              
              // Photo Upload Section
              _buildPhotoUploadSection(),
              const SizedBox(height: 25),
              
              // Manual Selection Section
              _buildManualSelectionSection(),
              const SizedBox(height: 30),
              
              // Results & Recommendations
              if (selectedTone != null) _buildResults(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFEFEBE9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFF5D4037)),
                const SizedBox(width: 8),
                const Text(
                  'How It Works',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Take a clear photo of your inner wrist in natural light',
              style: TextStyle(color: Color(0xFF5D4037)),
            ),
            const SizedBox(height: 5),
            const Text(
              '2. Or upload an existing photo from your gallery',
              style: TextStyle(color: Color(0xFF5D4037)),
            ),
            const SizedBox(height: 5),
            const Text(
              '3. Our AI will analyze your skin tone',
              style: TextStyle(color: Color(0xFF5D4037)),
            ),
            const SizedBox(height: 5),
            const Text(
              '4. You can also select your skin tone manually',
              style: TextStyle(color: Color(0xFF5D4037)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFD7CCC8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildUploadButton(
                    icon: Icons.camera_alt,
                    label: 'Take Photo',
                    onPressed: () => _capturePhoto(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildUploadButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () => _uploadPhoto(),
                  ),
                ),
              ],
            ),
            if (isAnalyzing) ...[
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D4037)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Analyzing skin tone...',
                      style: TextStyle(color: Color(0xFF5D4037)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildManualSelectionSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFEFEBE9),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Or Select Manually',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: skinTones.map((tone) {
                final isSelected = selectedTone == tone['name'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTone = tone['name'];
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: tone['color'],
                      border: Border.all(
                        color: isSelected ? const Color(0xFF5D4037) : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF5D4037)
                                : Colors.black.withOpacity(0.5),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(7),
                            ),
                          ),
                          child: Text(
                            tone['name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    // Find the selected skin tone data
    final toneData = skinTones.firstWhere(
      (tone) => tone['name'] == selectedTone,
      orElse: () => skinTones[0],
    );

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: const Color(0xFFA1887F),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: toneData['color'],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Your Skin Tone: ${toneData['name']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              toneData['description'],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/recommend-clothes', arguments: {
                  'skinTone': selectedTone,
                });
              },
              child: const Text(
                'Get Clothing Recommendations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTone = null;
                });
              },
              child: const Text(
                'Reset Selection',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _capturePhoto() {
    // Here you would implement camera functionality
    // For demonstration purposes, we'll simulate analysis
    setState(() {
      isAnalyzing = true;
    });
    
    // Simulate delay for analysis
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        selectedTone = 'Medium'; // Example result
        isAnalyzing = false;
      });
    });
  }

  void _uploadPhoto() {
    // Here you would implement photo upload functionality
    // For demonstration purposes, we'll simulate analysis
    setState(() {
      isAnalyzing = true;
    });
    
    // Simulate delay for analysis
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        selectedTone = 'Light'; // Example result
        isAnalyzing = false;
      });
    });
  }
}