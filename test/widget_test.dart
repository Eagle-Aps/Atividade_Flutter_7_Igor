import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:atividade_flutter_7_igor/main.dart';

Future<void> cadastrar(WidgetTester tester) async {
  final botao = find.widgetWithText(ElevatedButton, 'CADASTRAR');
  await tester.pumpAndSettle();
  await tester.ensureVisible(botao);
  await tester.pumpAndSettle();
  await tester.tap(botao);
  await tester.pumpAndSettle();
}

Future<void> preencher(
  WidgetTester tester, {
  String email = 'igor@exemplo.com',
  String senha = '123456',
}) async {
  final campos = find.byType(TextFormField);
  await tester.enterText(campos.at(0), 'Igor Exemplo');
  await tester.enterText(campos.at(1), email);
  await tester.enterText(campos.at(2), '12345678901');
  await tester.enterText(campos.at(3), '31999999999');
  await tester.enterText(campos.at(4), senha);
}

void main() {
  testWidgets('Exibe os cinco erros obrigatórios e SnackBar de erro', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());
    await cadastrar(tester);

    for (final mensagem in [
      'Informe seu nome completo.',
      'Informe seu e-mail.',
      'Informe seu CPF.',
      'Informe seu telefone.',
      'Informe uma senha.',
    ]) {
      expect(find.text(mensagem), findsOneWidget);
    }
    expect(
      find.text('Revise os campos destacados para continuar.'),
      findsOneWidget,
    );
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      const Color(0xFFBA1A1A),
    );
  });

  testWidgets('Rejeita e-mail sem @ e senha com menos de seis caracteres', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());
    await preencher(tester, email: 'igor.exemplo.com', senha: '12345');
    await cadastrar(tester);

    expect(
      find.text('Informe um e-mail válido, como nome@exemplo.com.'),
      findsOneWidget,
    );
    expect(
      find.text('A senha deve ter no mínimo 6 caracteres.'),
      findsOneWidget,
    );
    expect(find.textContaining('Cadastro realizado com sucesso'), findsNothing);
  });

  testWidgets('Filtra letras, pontuação e espaços em CPF e telefone', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(2), 'abc123.456.789-01');
    await tester.enterText(campos.at(3), '(31) 99999-9999xyz');

    final entradas = tester.widgetList<EditableText>(find.byType(EditableText));
    expect(entradas.elementAt(2).controller.text, '12345678901');
    expect(entradas.elementAt(3).controller.text, '31999999999');
  });

  testWidgets('Aceita dados válidos e senha de exatamente seis caracteres', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());
    await preencher(tester);
    await cadastrar(tester);

    expect(
      find.text('Cadastro realizado com sucesso, Igor Exemplo!'),
      findsOneWidget,
    );
    expect(find.textContaining('Informe '), findsNothing);
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      const Color(0xFF237A4B),
    );
  });

  testWidgets('Permite mostrar e ocultar a senha sem perder o texto', (
    tester,
  ) async {
    await tester.pumpWidget(const CadastroApp());
    await tester.enterText(find.byType(TextFormField).at(4), 'segredo');
    expect(
      tester
          .widgetList<EditableText>(find.byType(EditableText))
          .last
          .obscureText,
      isTrue,
    );

    await tester.ensureVisible(find.byTooltip('Mostrar senha'));
    await tester.tap(find.byTooltip('Mostrar senha'));
    await tester.pumpAndSettle();
    var senha = tester.widgetList<EditableText>(find.byType(EditableText)).last;
    expect(senha.obscureText, isFalse);
    expect(senha.controller.text, 'segredo');

    await tester.tap(find.byTooltip('Ocultar senha'));
    await tester.pumpAndSettle();
    senha = tester.widgetList<EditableText>(find.byType(EditableText)).last;
    expect(senha.obscureText, isTrue);
    expect(senha.controller.text, 'segredo');
  });

  testWidgets('Permite cadastrar em tela pequena sem overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const CadastroApp());
    await preencher(tester);
    await cadastrar(tester);
    expect(tester.takeException(), isNull);
    expect(
      find.text('Cadastro realizado com sucesso, Igor Exemplo!'),
      findsOneWidget,
    );
  });
}
