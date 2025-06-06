import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/userregistrationmodel.dart';
import '../models/profilemodel.dart';
import '../models/instrumentmodel.dart';
import '../services/profileservice.dart';
import '../services/instrumentservice.dart';
import '../services/userservice.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Profile> profiles = [];
  List<Instrument> instruments = [];

  Profile? selectedProfile;
  Instrument? selectedInstrument;

  final _contactController = TextEditingController();

  bool isLoading = false;

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    try {
      final loadedProfiles = await ProfileService().getProfiles();
      final loadedInstruments = await InstrumentService().getInstruments();
      setState(() {
        profiles = loadedProfiles;
        instruments = loadedInstruments;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _submit(BuildContext context, UserRegistration basicData) async {
    if (!_formKey.currentState!.validate() ||
        selectedProfile == null ||
        selectedInstrument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }

    setState(() => isLoading = true);

    final userPayload = UserRegistration(
      name: basicData.name,
      surname: basicData.surname,
      email: basicData.email,
      password: basicData.password,
      username: basicData.username,
      contact: _contactController.text,
      instrumentId: selectedInstrument!.id,
      profileId: selectedProfile!.id,
      roles: [selectedProfile!.name], 
    );

    final success = await UserService().registerUser(userPayload.toJson());

    setState(() => isLoading = false);

    if (success) {
      Navigator.pushNamed(context, '/tutorial');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao criar usuário')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData =
        ModalRoute.of(context)!.settings.arguments as UserRegistration;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Vamos completar o seu perfil",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Queremos saber mais sobre você"),
                  const SizedBox(height: 24),
                  _buildDropdownField<Profile>(
                    icon: Icons.emoji_people,
                    hint: "Perfil",
                    value: selectedProfile,
                    items: profiles,
                    onChanged: (p) => setState(() => selectedProfile = p),
                  ),
                  _buildDropdownField<Instrument>(
                    icon: Icons.music_note,
                    hint: "Instrumento",
                    value: selectedInstrument,
                    items: instruments,
                    onChanged: (i) => setState(() => selectedInstrument = i),
                  ),
                  _buildTextField(
                    Icons.phone,
                    "Contato",
                    _contactController,
                    inputFormatters: [phoneMaskFormatter],
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      if (value.length < 14) {
                        return 'Telefone incompleto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE899),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: isLoading ? null : () => _submit(context, userData),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Próximo"),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required IconData icon,
    required String hint,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFEFF3F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        items: items.map((item) {
          final name = (item is Profile) ? item.name : (item as Instrument).name;
          return DropdownMenuItem<T>(
            value: item,
            child: Text(name),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFEFF3F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator ??
            (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}
