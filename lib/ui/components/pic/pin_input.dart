import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final Function(String) onSubmit;
  final int minLength;
  final int maxLength;
  final String? errorText;

  const PinInput({
    Key? key,
    required this.onSubmit,
    this.minLength = 4,
    this.maxLength = 6,
    this.errorText,
  }) : super(key: key);

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  String _pin = '';
  final List<String> _numbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];

  void _onNumberPressed(String number) {
    if (_pin.length < widget.maxLength) {
      setState(() {
        _pin += number;
      });
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onClearPressed() {
    setState(() {
      _pin = '';
    });
  }

  void _onSubmit() {
    if (_pin.length >= widget.minLength && _pin.length <= widget.maxLength) {
      widget.onSubmit(_pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PIN Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.maxLength,
              (index) => Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < _pin.length ? Colors.black : Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
        const SizedBox(height: 10),
        // Number Pad
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index == 9) {
              return _buildButton('', onPressed: _onClearPressed);
            } else if (index == 10) {
              return _buildButton('0', onPressed: () => _onNumberPressed('0'));
            } else if (index == 11) {
              return _buildButton('', onPressed: _onSubmit);
            } else {
              return _buildButton(
                _numbers[index],
                onPressed: () => _onNumberPressed(_numbers[index]),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildButton(String text, {required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: text.isEmpty
              ? Icon(
                  text == '0' ? Icons.check_circle : Icons.clear,
                  color: text == '0' ? Colors.green : Colors.grey[700],
                  size: 20,
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
} 