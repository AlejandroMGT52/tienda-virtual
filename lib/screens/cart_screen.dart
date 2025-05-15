import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_virtual_flutter/providers/cart_provider.dart';
import 'package:tienda_virtual_flutter/utils/app_styles.dart';
import 'package:tienda_virtual_flutter/models/cart_item.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Carrito',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppStyles.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Tu carrito está vacío',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems.elementAt(index);
                        return _buildCartItem(item, cartProvider);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCartTotal(cartProvider),
                  const SizedBox(height: 30),
                  _buildCartButtons(context, cartProvider),
                ],
              ),
            ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cartProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(item.product.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppStyles.textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item.product.category,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppStyles.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              _buildQuantityButton(
                Icons.add,
                () => cartProvider.addToCart(item.product),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildQuantityButton(
                Icons.remove,
                () => cartProvider.removeFromCart(item.product),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
              cartProvider.deleteFromCart(item.product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppStyles.textColor),
      ),
    );
  }

  Widget _buildCartTotal(CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textColor)),
          Text('\$${cartProvider.getCartTotal().toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.primaryColor)),
        ],
      ),
    );
  }

  Widget _buildCartButtons(BuildContext context, CartProvider cartProvider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildConfirmationDialog(
                  context,
                  'Vaciar Carrito',
                  '¿Estás seguro de que quieres vaciar tu carrito?',
                  () {
                    cartProvider.clearCart();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Carrito vaciado')),
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child:
                const Text('Vaciar Carrito', style: TextStyle(fontSize: 17)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final option = await showModalBottomSheet<String>(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: const Text("Descargar Factura PDF"),
                      onTap: () => Navigator.pop(context, 'download'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.print),
                      title: const Text("Imprimir Factura"),
                      onTap: () => Navigator.pop(context, 'print'),
                    ),
                  ],
                ),
              );

              if (option != null) {
                await _generateAndPrintPdf(
                  context,
                  cartProvider.cartItems,
                  cartProvider.getCartTotal(),
                  print: option == 'print',
                );
                cartProvider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Factura generada. Gracias por tu compra.')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyles.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Generar Factura', style: TextStyle(fontSize: 17)),
          ),
        ),
      ],
    );
  }

  Future<void> _generateAndPrintPdf(
    BuildContext context,
    List<CartItem> cartItems,
    double total, {
    required bool print,
  }) async {
    final pdf = pw.Document();

    Uint8List? logoBytes;
    try {
      final data = await rootBundle.load('assets/images/logo-nuevo.png');
      logoBytes = data.buffer.asUint8List();
    } catch (e) {
      logoBytes = null;
    }

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(30),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (logoBytes != null)
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Image(pw.MemoryImage(logoBytes), width: 120),
              ),
            pw.SizedBox(height: 16),
            pw.Text('Factura de Compra',
                style: pw.TextStyle(
                    fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Text('Fecha: ${DateTime.now().toString().split(' ')[0]}'),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Producto', 'Cantidad', 'Precio Unit.', 'Total'],
              data: cartItems
                  .map((item) => [
                        item.product.title,
                        item.quantity.toString(),
                        '\$${item.product.price.toStringAsFixed(2)}',
                        '\$${(item.quantity * item.product.price).toStringAsFixed(2)}'
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.blueGrey800),
              cellStyle: const pw.TextStyle(fontSize: 10),
              border: pw.TableBorder.all(color: PdfColors.grey300),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Subtotal: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      '\$${(total / 1.16).toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 12))
                ]),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('IVA (16%): ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('\$${(total * 0.16 / 1.16).toStringAsFixed(2)}',
                      style: const pw.TextStyle(fontSize: 12))
                ]),
            pw.Divider(),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Total a Pagar: ',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text('\$${total.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16))
                ]),
            pw.SizedBox(height: 30),
            pw.Text('Gracias por tu compra!',
                style: const pw.TextStyle(fontSize: 12)),
          ],
        );
      },
    ));

    final pdfBytes = await pdf.save();
    if (print) {
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    } else {
      await Printing.sharePdf(bytes: pdfBytes, filename: 'factura.pdf');
    }
  }

  Widget _buildConfirmationDialog(
      BuildContext context, String title, String content, VoidCallback onConfirm) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.secondaryColor,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
