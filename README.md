# Atividade Flutter 7 — Igor

Formulário de cadastro de usuário desenvolvido em Flutter para a atividade prática.

## Executar no VS Code

1. Abra esta pasta no VS Code e instale a extensão **Flutter** (ela também instala a extensão Dart).
2. No terminal, execute `flutter pub get`.
3. Selecione **Chrome** ou um emulador Android na barra inferior e pressione **F5**.

Também é possível executar pelo terminal:

```bash
flutter run -d chrome
```

## Requisitos implementados

- `Scaffold > Form(key: _formKey) > SingleChildScrollView > Column`.
- Nome completo, e-mail, CPF, telefone e senha com `TextFormField`.
- Todos os campos obrigatórios e erros individuais abaixo de cada campo.
- Teclados adequados e `FilteringTextInputFormatter.digitsOnly` em CPF e telefone.
- E-mail validado com RegExp e senha com pelo menos 6 caracteres.
- Botão **CADASTRAR** que valida e captura os valores com `FormState.save()` e `onSaved`.
- SnackBar verde de sucesso e vermelho quando o formulário contém erros.
- Botão para mostrar ou ocultar a senha.
- Rolagem para telas pequenas e teclado aberto; espaçamento de 16 px entre os campos.

O cadastro é uma demonstração local: não cria contas em um servidor e não persiste os dados.
CPF e telefone seguem a regra da atividade (obrigatórios e somente números), sem exigir comprimento ou dígitos verificadores.

## Verificação

```bash
flutter analyze
flutter test
flutter build web
```

## Entrega

1. Execute o app, preencha os campos com dados fictícios e clique em **CADASTRAR**.
2. Capture a tela com a mensagem de sucesso. Evite dados pessoais reais no print.
3. Publique esta pasta em um repositório no GitHub.
4. Envie o link do repositório e o print pelo AVA.

Arquivo principal: `lib/main.dart`.
