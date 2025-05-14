import 'package:flutter/material.dart';

class PinInput extends StatefulWidget {
  final Function(String) onSubmit;
  final int pinLength;
  final String? errorText;

  const PinInput({
    super.key,
    required this.onSubmit,
    this.pinLength = 6,
    this.errorText,
  });

  @override
  State<PinInput> createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  String _pin = '';
  final List<String> _numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  void _onNumberPressed(String number) {
    if (_pin.length < widget.pinLength) {
      setState(() {
        _pin += number;
      });
      if (_pin.length == widget.pinLength) {
        widget.onSubmit(_pin);
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PIN Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.pinLength,
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
        const SizedBox(height: 15),
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
              return Container();
            } else if (index == 10) {
              return _buildButton('0', onPressed: () => _onNumberPressed('0'));
            } else if (index == 11) {
              return _buildButton('delete', onPressed: _onBackspacePressed);
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(5),
        child: Center(
          child: text == 'delete'
              ? Icon(
                  Icons.backspace,
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
