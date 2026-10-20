import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';

class CreatorUploadScreen extends StatefulWidget {
  final int userId;
  final String userEmail;
  final bool isCreator;

  const CreatorUploadScreen({
    super.key,
    required this.userId,
    required this.userEmail,
    required this.isCreator,
  });

  @override
  State<CreatorUploadScreen> createState() => _CreatorUploadScreenState();
}

class _CreatorUploadScreenState extends State<CreatorUploadScreen> {
  bool _isCreator = false;
  bool _isLoading = false;
  
  // Upload form controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedMediaType = 'video'; // 'video', 'music', 'pod'
  File? _selectedFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _isCreator = widget.isCreator;
  }

  // 1. Initialize Paystack ₦3,000 Creator Fee
  Future<void> _payCreatorFee() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://yourdomain.com/api/initialize_creator_fee.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': widget.userId,
          'email': widget.userEmail,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final authUrl = data['authorization_url'];
        
        // Launch Paystack payment checkout URL in browser/webview
        final Uri url = Uri.parse(authUrl);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch payment page')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Payment initialization failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 2. Pick Media File (Video / Audio)
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  // 3. Upload Media to cPanel Backend
  Future<void> _uploadMedia() async {
    if (_selectedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file and provide a title')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://yourdomain.com/api/upload_media.php'),
      );

      request.fields['user_id'] = widget.userId.toString();
      request.fields['media_type'] = _selectedMediaType;
      request.fields['title'] = _titleController.text.trim();
      request.fields['description'] = _descController.text.trim();

      request.files.add(
        await http.MultipartFile.fromPath('media_file', _selectedFile!.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Media uploaded successfully!')),
        );
        _titleController.clear();
        _descController.clear();
        setState(() {
          _selectedFile = null;
          _fileName = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Upload failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload error. Check file size limits.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuzzle Creator Studio'),
        backgroundColor: AppTheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isCreator ? _buildUploadForm() : _buildUpgradePrompt(),
      ),
    );
  }

  // UI when user hasn't paid ₦3,000 yet
  Widget _buildUpgradePrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified, size: 80, color: AppTheme.primary),
          const SizedBox(height: 20),
          const Text(
            'Unlock Publishing Rights',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pay a one-time creator fee of ₦3,000 to upload videos, music, and podcasts, get a Verified Badge, and qualify for 50% Ad Revenue Share.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textGray),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _payCreatorFee,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Pay ₦3,000 Creator Fee', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // UI for verified creators to upload media
  Widget _buildUploadForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Upload New Media',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedMediaType,
            dropdownColor: AppTheme.cardColor,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Media Type'),
            items: const [
              DropdownMenuItem(value: 'video', child: Text('Long Video (Max 150MB)')),
              DropdownMenuItem(value: 'music', child: Text('Music Track (Max 30MB)')),
              DropdownMenuItem(value: 'pod', child: Text('Podcast Episode (Max 30MB)')),
            ],
            onChanged: (val) => setState(() => _selectedMediaType = val!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(_fileName ?? 'Select File from Device'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _uploadMedia,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Publish Media', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
