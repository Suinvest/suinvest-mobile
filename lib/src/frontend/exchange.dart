// import 'package:flutter/material.dart';

// class ExchangePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Exchange Cryptocurrency'),
//       ),
//       body: ExchangeForm(),
//     );
//   }
// }

// class ExchangeForm extends StatefulWidget {
//   @override
//   _ExchangeFormState createState() => _ExchangeFormState();
// }

// class _ExchangeFormState extends State<ExchangeForm> {
//   final _formKey = GlobalKey<FormState>();
//   String _fromCurrency = 'Bitcoin';
//   String _toCurrency = 'Ethereum';
//   double _exchangeRate = 0.0;
//   double _exchangeAmount = 0.0;
//   double _estimatedAmount = 0.0;

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           DropdownButtonFormField<String>(
//             value: _fromCurrency,
//             items: <String>['Bitcoin', 'Ethereum', 'Litecoin', 'Dogecoin']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _fromCurrency = value;
//               });
//               calculateEstimatedAmount();
//             },
//             decoration: InputDecoration(
//               labelText: 'From',
//             ),
//           ),
//           TextFormField(
//             keyboardType: TextInputType.number,
//             onChanged: (value) {
//               setState(() {
//                 _exchangeAmount = double.tryParse(value) ?? 0.0;
//               });
//               calculateEstimatedAmount();
//             },
//             decoration: InputDecoration(
//               labelText: 'Amount',
//             ),
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter an amount';
//               }
//               return null;
//             },
//           ),
//           DropdownButtonFormField<String>(
//             value: _toCurrency,
//             items: <String>['Bitcoin', 'Ethereum', 'Litecoin', 'Dogecoin']
//                 .map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _toCurrency = value;
//               });
//               calculateEstimatedAmount();
//             },
//             decoration: InputDecoration(
//               labelText: 'To',
//             ),
//           ),
//           TextFormField(
//             readOnly: true,
//             initialValue: _estimatedAmount.toStringAsFixed(2),
//             decoration: InputDecoration(
//               labelText: 'Estimated Amount',
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Center(
//             child: RaisedButton(
//               onPressed: () {
//                 if (_formKey.currentState.validate()) {
//                   submitExchangeRequest();
//                 }
//               },
//               child: Text('Exchange'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void submitExchangeRequest() {
//     // TODO: Send exchange request to SUI chain API
//   }

//   void calculateEstimatedAmount() {
//     // TODO: Calculate estimated amount based on exchange rate
//     setState(() {
//       _estimatedAmount = _exchangeAmount * _exchangeRate;
//     });
//   }
// }
