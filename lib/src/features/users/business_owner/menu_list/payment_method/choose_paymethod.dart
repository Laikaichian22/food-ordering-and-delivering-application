import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/constants/decoration.dart';
import 'package:flutter_application_1/src/features/users/business_owner/menu_list/payment_method/cod_replacemeal_method/cod_or_replace_page.dart';
import 'package:flutter_application_1/src/routing/routes_const.dart';

class ChoosePaymentMethodPage extends StatefulWidget {
  const ChoosePaymentMethodPage({super.key});

  @override
  State<ChoosePaymentMethodPage> createState() => _ChoosePaymentMethodPageState();
}

class _ChoosePaymentMethodPageState extends State<ChoosePaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ownerColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                payMethodPageRoute, 
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.arrow_back_outlined, 
              color: iconWhiteColor
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    textAlign: TextAlign.center,
                    'Please select one of the payment method below.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 20),
                  CardPaymentMethodWidget(
                    title: "Touch' n Go eWallet",  
                    imageIcon: 'images/tng.png',
                    onTap: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        payMethodTnGRoute, 
                        (route) => false,
                      );
                    }
                  ),
                  const SizedBox(height: 15),
                  CardPaymentMethodWidget(
                    title: "Online banking/FPX", 
                    imageIcon: 'images/banking.png',
                    onTap: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        payMethodOnlineBankingRoute, 
                        (route) => false,
                      );
                    }
                  ),
                  const SizedBox(height: 15),
                  CardPaymentMethodWidget(
                    title: "Cash on Delivery(COD)", 
                    imageIcon: 'images/cash-on-delivery.png',
                    onTap: (){
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const ReplaceMealOrCODPage(choice: 'COD'),
                      );
                      Navigator.pushReplacement(context, route);
                    }
                  ),
                  const SizedBox(height: 15),
                  CardPaymentMethodWidget(
                    title: "Replace meal", 
                    imageIcon: 'images/replace-meal.png',
                    onTap: (){
                      MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const ReplaceMealOrCODPage(choice: 'Replace meal'),
                      );
                      Navigator.pushReplacement(context, route);
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardPaymentMethodWidget extends StatelessWidget {
  const CardPaymentMethodWidget({
    required this.title,
    required this.imageIcon,
    required this.onTap,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final String imageIcon;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
          width: width*0.5,
          height: height*0.2,
          child: Card(
            clipBehavior: Clip.hardEdge,
            shadowColor: const Color.fromARGB(255, 116, 192, 255),
            elevation: 9,
            color: const Color.fromARGB(255, 226, 226, 226),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    imageIcon,
                    height: 90,
                    width: 90,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}