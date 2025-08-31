import 'package:flutter/material.dart';

/// Widget que automaticamente ajusta o comportamento do scroll quando o teclado aparece
/// Especialmente útil para ambientes web onde o teclado pode sobrepor o conteúdo
class KeyboardAwareScrollView extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool reverse;
  final Axis scrollDirection;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const KeyboardAwareScrollView({
    super.key,
    required this.child,
    this.padding,
    this.controller,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  });

  @override
  State<KeyboardAwareScrollView> createState() =>
      _KeyboardAwareScrollViewState();
}

class _KeyboardAwareScrollViewState extends State<KeyboardAwareScrollView>
    with WidgetsBindingObserver {
  late ScrollController _scrollController;
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomInset != _keyboardHeight) {
      setState(() {
        _keyboardHeight = bottomInset;
      });

      // Se o teclado apareceu, scroll para garantir que o campo focado seja visível
      if (bottomInset > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _ensureFocusedFieldVisible();
        });
      }
    }
  }

  void _ensureFocusedFieldVisible() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      return;
    }

    // Scroll para baixo para garantir que o campo focado seja visível
    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      final keyboardHeight = _keyboardHeight;

      // Se necessário, scroll para baixo
      if (position.pixels < position.maxScrollExtent) {
        _scrollController.animateTo(
          position.pixels + (keyboardHeight * 0.3),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      padding: widget.padding,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      child: Column(
        children: [
          widget.child,
          // Adiciona um espaço extra quando o teclado está aberto
          // para garantir que o conteúdo não fique escondido
          if (_keyboardHeight > 0) SizedBox(height: _keyboardHeight * 0.1),
        ],
      ),
    );
  }
}
