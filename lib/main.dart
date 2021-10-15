import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var theme = ThemeData(
    //   primarySwatch: Colors.blueGrey,
    //   fontFamily: 'Quicksand',
    //   textTheme: ThemeData.light().textTheme.copyWith(
    //         headline6: TextStyle(
    //           fontFamily: 'OpenSans',
    //           fontSize: 18,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //   buttonTheme: ButtonThemeData(
    //     buttonColor: Colors.amber, //  <-- light color
    //     textTheme:
    //         ButtonTextTheme.primary, //  <-- dark text for light background
    //   ),
    //   appBarTheme: AppBarTheme(
    //     titleTextStyle: TextStyle(
    //       fontFamily: 'OpenSans',
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
    var theme = ThemeData(
      primarySwatch: Colors.blueGrey,
      fontFamily: 'Quicksand',
      textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        secondary: Colors.green,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber, //  <-- light color
        textTheme:
            ButtonTextTheme.primary, //  <-- dark text for light background
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return MaterialApp(
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: Colors.amber,
        ),
      ),
      title: 'Personal Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // var amountInput = '';
  // var titleInput = '';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', title: 'New shoes', amount: 69.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly groceries',
    //     amount: 69.99,
    //     date: DateTime.now()),
  ];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('AppLifecycleState state: $state');
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _deleteTransaction(String id) {
    _userTransactions.removeWhere((element) => element.id == id);
    setState(() {});
  }

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    print('title: $title, amount: $amount');

    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: selectedDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: SingleChildScrollView(
                // padding:
                //     EdgeInsets.only(top: mediaQuery.viewInsets.top),
                child:
                    NewTransaction(newTransactionHandler: _addNewTransaction)),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQueryData,
      PreferredSizeWidget appBar, Container txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart', style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
            value: _showChart,
            onChanged: (bool value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart ? chartContainer(mediaQueryData, appBar) : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQueryData,
      PreferredSizeWidget appBar, Container txListWidget) {
    return [chartContainer(mediaQueryData, appBar), txListWidget];
  }

  @override
  Widget build(BuildContext context) {
    print('build() main.MyHomePageState');

    var mediaQueryData = MediaQuery.of(context);
    var isLandscape = mediaQueryData.orientation == Orientation.landscape;
    PreferredSizeWidget appBar = _createAppBar(context);
    var txListWidget = Container(
      height: resizeHeight(mediaQueryData, appBar, 0.7),
      child: TransactionList(
          transactions: _userTransactions,
          deleteTransactionHandler: _deleteTransaction),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody(isLandscape, mediaQueryData, appBar, txListWidget),
            navigationBar: appBar as ObstructingPreferredSizeWidget,
          )
        : Scaffold(
            // backgroundColor: Colors.black,
            appBar: appBar,
            body: pageBody(isLandscape, mediaQueryData, appBar, txListWidget),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
          );
  }

  PreferredSizeWidget _createAppBar(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _startAddNewTransaction(context);
                  },
                  child: Icon(CupertinoIcons.add),
                  behavior: HitTestBehavior.opaque,
                ),
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: Text('Personal Expenses'),
            elevation: 5,
            actions: [
              IconButton(
                  onPressed: () {
                    _startAddNewTransaction(context);
                  },
                  icon: Icon(Icons.add, color: Colors.white)),
            ],
          );
    return appBar;
  }

  SafeArea pageBody(bool isLandscape, MediaQueryData mediaQueryData,
      PreferredSizeWidget appBar, Container txListWidget) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              ..._buildLandscapeContent(mediaQueryData, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQueryData, appBar, txListWidget),
          ],
        ),
      ),
    );
  }

  Container chartContainer(
      MediaQueryData mediaQueryData, PreferredSizeWidget appBar) {
    return Container(
      height: resizeHeight(mediaQueryData, appBar, 0.3),
      child: Chart(recentTransactions: _recentTransactions),
    );
  }

  double resizeHeight(
      MediaQueryData mediaQueryData, PreferredSizeWidget appBar, double ratio) {
    return (mediaQueryData.size.height -
            // Subtract appBar
            appBar.preferredSize.height -
            // Subtract status bar
            mediaQueryData.padding.top) *
        ratio;
  }
}
