import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _roadSigns = [];
  late Database? db;

  @override
  void initState() {
    super.initState();
    _openDatabase();
    _loadRoadSigns();
  }

  @override
  void dispose() {
    _closeDatabase();
    super.dispose();
  }

  Future<void> _openDatabase() async {
    db = await openDatabase(
      path.join(
        await getDatabasesPath(),
        'roadsign.db',
      ),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE road_signs(latitude REAL, longitude REAL, imagePath TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> _closeDatabase() async {
    if (db != null) {
      await db!.close();
    }
  }

  Future<List<Map<String, dynamic>>> _getAllRoadSigns() async {
    final List<Map<String, dynamic>> maps = await db!.query('road_signs');
    return maps;
  }

  Future<int> _insertRoadSign(Map<String, dynamic> row) async {
    return await db!.insert('road_signs', row);
  }

  Future<void> _loadRoadSigns() async {
    List<Map<String, dynamic>> roadSigns = await _getAllRoadSigns();
    setState(() {
      _roadSigns = roadSigns;
    });
  }

  Future<void> _recordRoadSign() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );

    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath =
          path.join(directory.path, path.basename(image.path));
      await image.saveTo(imagePath);

      await _insertRoadSign({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'imagePath': imagePath,
      });

      _loadRoadSigns();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Signs Recorder'),
      ),
      // body: ListView.builder(
      //   itemCount: _roadSigns.length,
      //   itemBuilder: (context, index) {
      //     final roadSign = _roadSigns[index];
      //     return ListTile(
      //       leading: Image.file(File(roadSign['imagePath'])),
      //       title: Text(
      //           'Location: (${roadSign['latitude']}, ${roadSign['longitude']})'),
      //     );
      //   },
      // ),
      body: Center(
        child: Text('Number of road signs: ${_roadSigns.length}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recordRoadSign,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
