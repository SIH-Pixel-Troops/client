import 'package:flutter/material.dart';
import 'home_screen.dart';

enum TouristType { foreign, indian }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TouristType _type = TouristType.foreign;
  final TextEditingController _visaController = TextEditingController();
  bool _submitting = false;
  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'China',
    'Japan',
    'Australia',
    'Germany',
    'France',
    'Canada',
    'Other',
  ];
  String? _selectedCountry;

  @override
  void dispose() {
    _visaController.dispose();
    super.dispose();
  }

  void _submitVisa() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final visa = _visaController.text.trim();
    // TODO: replace with real login/network call
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visa submitted: $visa')),
      );
      // Navigate to HomeScreen after successful submit
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  void _loginWithDigilocker() {
    // Placeholder for actual Digilocker OAuth flow
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Digilocker login not implemented yet')),
    // );
    // Navigate to HomeScreen after Digilocker login
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: colors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Please select how you would like to login',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 18),

              // Tourist type toggle
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Foreign Tourist'),
                      selected: _type == TouristType.foreign,
                      onSelected: (s) => setState(() {
                        _type = TouristType.foreign;
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Indian (Digilocker)'),
                      selected: _type == TouristType.indian,
                      onSelected: (s) => setState(() {
                        _type = TouristType.indian;
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              if (_type == TouristType.foreign) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country selector (only for foreign tourists)
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                        ),
                        items: _countries
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedCountry = v),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please select your country';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _visaController,
                        decoration: const InputDecoration(
                          labelText: 'Visa Number',
                          hintText: 'Enter your visa number',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Visa number is required';
                          }
                          if (v.trim().length < 4) {
                            return 'Enter a valid visa number';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submitVisa(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _submitVisa,
                          child: _submitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const Text(
                  'Login using DigiLocker',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  'If you are an Indian tourist, you can login using DigiLocker to quickly share verified identity documents.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.lock),
                    label: const Text('Login with DigiLocker'),
                    onPressed: _loginWithDigilocker,
                  ),
                ),
              ],

              const Spacer(),
              Center(
                child: Text(
                  'We respect your privacy. Your data is used only for safety services.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
