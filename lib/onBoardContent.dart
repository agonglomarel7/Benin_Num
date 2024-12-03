

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/listContact.dart';

class onBoardScreen extends StatefulWidget {
  const onBoardScreen({super.key});

  @override
  State<onBoardScreen> createState() => _onBoardScreenState();
}

class _onBoardScreenState extends State<onBoardScreen> {

  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState(){
    _pageController = PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                    itemCount: screen_data.length,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex =index;
                      });
                    },
                    itemBuilder: (
                        context,index)=>
                        onBoardContent(
                            image: screen_data[index].image,
                            title: screen_data[index].title,
                            description: screen_data[index].description
                        )),
              ),
              Row(children: [
                const Spacer(),
                SizedBox(
                  height: 100,
                  width: 50,
                  child: ElevatedButton(onPressed: (){
                    _navigateToNextPage();
                  },
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder()
                    ),
                    child: Icon(
                      _currentIndex == screen_data.length - 1
                          ? Icons.check
                          : Icons.arrow_forward,
                    ),

                )
                )],)
            ]),
      )
      ),
    );
  }

  void _navigateToNextPage() {

    if (_currentIndex == screen_data.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Listcontact()),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard({required this.image, required this.title, required this.description});
}

final List<OnBoard> screen_data = [
  OnBoard(
    image: "assets/images/family.png",
    title: "Bienvenue à l'application",
    description: "Découvrez les fonctionnalités incroyables.",
  ),
  OnBoard(
    image: "assets/images/family.png",
    title: "Explorez le contenu",
    description: "Apprenez comment utiliser l'application.",
  ),
  OnBoard(
    image: "assets/images/family.png",
    title: "Prêt à commencer",
    description: "Lancez-vous maintenant et profitez.",
  ),
];

class onBoardContent extends StatelessWidget {
  const onBoardContent({super.key, required this.image, required this.title, required this.description});

  final String image,title,description;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              Image.asset(image ,height: 250,),
              const Spacer(),
              Text(title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w500,),
                textAlign: TextAlign.center ,
              ),
              const SizedBox(height: 25,),
              Text(description,textAlign: TextAlign.center,)
            ],)
      ),
    );
  }
}
