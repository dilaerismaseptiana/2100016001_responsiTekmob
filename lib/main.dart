import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  void _login() {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      if (username == '2100016001' && password == 'responsi_D') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: username,
            password: password,
          ),
        ));
      } else {
        setState(() {
          _errorMessage = "Invalid username or password";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value != '2100016001') {
                    return 'Invalid username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value != 'responsi_D') {
                    return 'Invalid password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String username;
  final String password;

  HomeScreen({required this.username, required this.password});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _bmiCategory = "";

  void _calculateBMI() {
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    if (height > 0 && weight > 0) {
      // Convert height from cm to meters
      height = height / 100;
      setState(() {
        _bmi = weight / (height * height);
        if (_bmi < 18.5) {
          _bmiCategory = "Underweight";
        } else if (_bmi >= 18.5 && _bmi < 25) {
          _bmiCategory = "Normal weight";
        } else {
          _bmiCategory = "Overweight";
        }
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Underweight":
        return Colors.red;
      case "Normal weight":
        return Colors.green;
      case "Overweight":
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: ${widget.username}'),
            Text('Password: ${widget.password}'),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              'Your Body Mass Index (BMI): ${_bmi.toStringAsFixed(1)}',
              style: TextStyle(color: _getCategoryColor(_bmiCategory)),
            ),
            Text(
              'Category: $_bmiCategory',
              style: TextStyle(color: _getCategoryColor(_bmiCategory)),
            ),
            SizedBox(height: 20),
            _buildBMICategoryChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildBMICategoryChart() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildCategoryIndicator("Underweight", Colors.red),
              _buildCategoryIndicator("Normal weight", Colors.green),
              _buildCategoryIndicator("Overweight", Colors.yellow),
            ],
          ),
          Container(
            height: 20,
            child: Row(
              children: [
                _buildRangeIndicator(10.0, Colors.red),
                _buildRangeIndicator(10.0, Colors.green),
                _buildRangeIndicator(10.0, Colors.yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIndicator(String category, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        SizedBox(width: 5),
        Text(category),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildRangeIndicator(double widthFactor, Color color) {
    return Expanded(
      flex: (widthFactor * 10).toInt(),
      child: Container(
        height: 10,
        color: color,
      ),
    );
  }
}
