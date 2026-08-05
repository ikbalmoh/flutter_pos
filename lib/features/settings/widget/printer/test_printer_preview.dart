import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TestPrinterPreview
//
// A widget that visually reproduces the content emitted by
// Printer.buildTestTicketBytes, so users can verify the layout before
// printing on physical hardware.
// ─────────────────────────────────────────────────────────────────────────────

const _receiptFont = TextStyle(
  fontFamily: 'Courier',
  fontSize: 12,
  color: Colors.black,
  height: 1.5,
);

class TestPrinterPreview extends StatelessWidget {
  const TestPrinterPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: _receiptFont,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── App icon ─────────────────────────────────────────────────────
            Center(
              child: Image.asset(
                'assets/images/icon-print.jpg',
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.store,
                  size: 80,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // ── Regular text ─────────────────────────────────────────────────
            const Text(
              'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ',
              style: _receiptFont,
            ),

            // ── Special characters ────────────────────────────────────────────
            const Text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ'),
            const Text('Special 2: blåbærgrød'),

            const SizedBox(height: 4),

            // ── Text styles ───────────────────────────────────────────────────
            const Text(
              'Bold text',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: const Text(
                'Reverse text',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Text(
              'Underlined text',
              style: TextStyle(decoration: TextDecoration.underline),
            ),

            const SizedBox(height: 4),

            // ── Alignment ─────────────────────────────────────────────────────
            const Text('Align left', textAlign: TextAlign.left),
            const Text('Align center', textAlign: TextAlign.center),
            const Text('Align right', textAlign: TextAlign.right),

            const SizedBox(height: 6),

            // ── Row columns ───────────────────────────────────────────────────
            _TicketRow(
              columns: const [
                _TicketColumn(text: 'col3', flex: 3, underline: true),
                _TicketColumn(text: 'col6', flex: 6, underline: true),
                _TicketColumn(text: 'col3', flex: 3, underline: true),
              ],
            ),

            const SizedBox(height: 6),

            // ── Large text (size 200%) ────────────────────────────────────────
            const Text(
              'Text size 200%',
              style: TextStyle(
                fontSize: 24, // double of base 12
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // ── QR code ───────────────────────────────────────────────────────
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.qr_code_2, size: 64, color: Colors.black),
                    Text(
                      'selleri.co.id',
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TicketRow  — mimics generator.row([PosColumn…])
// ─────────────────────────────────────────────────────────────────────────────

class _TicketColumn {
  final String text;
  final int flex;
  final bool underline;

  const _TicketColumn({
    required this.text,
    required this.flex,
    this.underline = false,
  });
}

class _TicketRow extends StatelessWidget {
  final List<_TicketColumn> columns;

  const _TicketRow({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns.map((col) {
        return Expanded(
          flex: col.flex,
          child: Text(
            col.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration:
                  col.underline ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        );
      }).toList(),
    );
  }
}
