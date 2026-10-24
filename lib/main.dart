import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    const corPrincipal = Color(0xFF6750A4);

    return MaterialApp(
      title: 'Cadastro de usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: corPrincipal),
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F5FA),
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD8D2E2)),
          ),
          errorMaxLines: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corPrincipal,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  // Os valores são capturados por onSaved somente após a validação.
  // Esta atividade demonstra o formulário, sem enviar dados para um servidor.
  final Map<String, String> _dadosCadastro = {};
  bool _ocultarSenha = true;
  bool _tentouCadastrar = false;

  String? _validarObrigatorio(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }
    return null;
  }

  String? _validarEmail(String? valor) {
    final erro = _validarObrigatorio(valor, 'seu e-mail');
    if (erro != null) return erro;

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(valor!.trim())) {
      return 'Informe um e-mail válido, como nome@exemplo.com.';
    }
    return null;
  }

  String? _validarNumeros(String? valor, String campo) {
    final erro = _validarObrigatorio(valor, campo);
    if (erro != null) return erro;

    if (!RegExp(r'^[0-9]+$').hasMatch(valor!)) {
      return 'Use apenas números.';
    }
    return null;
  }

  String? _validarSenha(String? valor) {
    final erro = _validarObrigatorio(valor, 'uma senha');
    if (erro != null) return erro;
    if (valor!.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  void _cadastrar() {
    FocusScope.of(context).unfocus();
    setState(() => _tentouCadastrar = true);
    final formulario = _formKey.currentState!;
    final valido = formulario.validate();
    final mensagens = ScaffoldMessenger.of(context);
    mensagens.hideCurrentSnackBar();

    if (!valido) {
      mensagens.showSnackBar(
        const SnackBar(
          content: Text('Revise os campos destacados para continuar.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    formulario.save();
    final nome = _dadosCadastro['nome']!;
    mensagens.showSnackBar(
      SnackBar(
        content: Text('Cadastro realizado com sucesso, $nome!'),
        backgroundColor: const Color(0xFF237A4B),
      ),
    );
    // Não mantenha a senha em memória após concluir a demonstração.
    _dadosCadastro.clear();
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.sizeOf(context).width;
    final margemLateral = largura > 528 ? (largura - 480) / 2 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de usuário')),
      body: Form(
        key: _formKey,
        autovalidateMode: _tentouCadastrar
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            margemLateral,
            16,
            margemLateral,
            32 + MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFE8DEF8),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 30,
                  color: Color(0xFF6750A4),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Crie sua conta',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF272136),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Preencha seus dados abaixo.\nTodos os campos são obrigatórios.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF625B71), height: 1.5),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (valor) =>
                    _validarObrigatorio(valor, 'seu nome completo'),
                onSaved: (valor) => _dadosCadastro['nome'] = valor!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  hintText: 'nome@exemplo.com',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                validator: _validarEmail,
                onSaved: (valor) => _dadosCadastro['email'] = valor!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Somente números',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                validator: (valor) => _validarNumeros(valor, 'seu CPF'),
                onSaved: (valor) => _dadosCadastro['cpf'] = valor!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: 'DDD e número, sem espaços',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                validator: (valor) => _validarNumeros(valor, 'seu telefone'),
                onSaved: (valor) => _dadosCadastro['telefone'] = valor!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'No mínimo 6 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    tooltip: _ocultarSenha ? 'Mostrar senha' : 'Ocultar senha',
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                    icon: Icon(
                      _ocultarSenha
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: _ocultarSenha,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: _validarSenha,
                onSaved: (valor) => _dadosCadastro['senha'] = valor!,
                onFieldSubmitted: (_) => _cadastrar(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text(
                  'CADASTRAR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
