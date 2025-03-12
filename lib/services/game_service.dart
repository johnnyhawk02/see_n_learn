import 'dart:math';
import '../models/pic_card.dart';

class GameService {
  final List<PicCard> _allCards = [
    PicCard(imagePath: 'assets/images/word-images/apple.jpeg', name: 'Apple'),
    PicCard(imagePath: 'assets/images/word-images/baby.jpeg', name: 'Baby'),
    PicCard(imagePath: 'assets/images/word-images/bag.jpeg', name: 'Bag'),
    PicCard(imagePath: 'assets/images/word-images/ball.jpeg', name: 'Ball'),
    PicCard(imagePath: 'assets/images/word-images/banana.jpeg', name: 'Banana'),
    PicCard(imagePath: 'assets/images/word-images/bath.jpeg', name: 'Bath'),
    PicCard(imagePath: 'assets/images/word-images/bear.jpeg', name: 'Bear'),
    PicCard(imagePath: 'assets/images/word-images/bed.jpeg', name: 'Bed'),
    PicCard(imagePath: 'assets/images/word-images/bird.jpeg', name: 'Bird'),
    PicCard(imagePath: 'assets/images/word-images/biscuit.jpeg', name: 'Biscuit'),
    PicCard(imagePath: 'assets/images/word-images/blocks.jpeg', name: 'Blocks'),
    PicCard(imagePath: 'assets/images/word-images/book.jpeg', name: 'Book'),
    PicCard(imagePath: 'assets/images/word-images/brush.jpeg', name: 'Brush'),
    PicCard(imagePath: 'assets/images/word-images/car.jpeg', name: 'Car'),
    PicCard(imagePath: 'assets/images/word-images/cat.jpeg', name: 'Cat'),
    PicCard(imagePath: 'assets/images/word-images/chair.jpeg', name: 'Chair'),
    PicCard(imagePath: 'assets/images/word-images/coat.jpeg', name: 'Coat'),
    PicCard(imagePath: 'assets/images/word-images/cow.jpeg', name: 'Cow'),
    PicCard(imagePath: 'assets/images/word-images/cup.jpeg', name: 'Cup'),
    PicCard(imagePath: 'assets/images/word-images/daddy.jpeg', name: 'Daddy'),
    PicCard(imagePath: 'assets/images/word-images/dog.jpeg', name: 'Dog'),
    PicCard(imagePath: 'assets/images/word-images/doll.jpeg', name: 'Doll'),
    PicCard(imagePath: 'assets/images/word-images/drink.jpeg', name: 'Drink'),
    PicCard(imagePath: 'assets/images/word-images/duck.jpeg', name: 'Duck'),
    PicCard(imagePath: 'assets/images/word-images/eyes.jpeg', name: 'Eyes'),
    PicCard(imagePath: 'assets/images/word-images/fish.jpeg', name: 'Fish'),
    PicCard(imagePath: 'assets/images/word-images/flower.jpeg', name: 'Flower'),
    PicCard(imagePath: 'assets/images/word-images/hair.jpeg', name: 'Hair'),
    PicCard(imagePath: 'assets/images/word-images/hat.jpeg', name: 'Hat'),
    PicCard(imagePath: 'assets/images/word-images/keys.jpeg', name: 'Keys'),
    PicCard(imagePath: 'assets/images/word-images/mouth.jpeg', name: 'Mouth'),
    PicCard(imagePath: 'assets/images/word-images/mummy.jpeg', name: 'Mummy'),
    PicCard(imagePath: 'assets/images/word-images/nose.jpeg', name: 'Nose'),
    PicCard(imagePath: 'assets/images/word-images/phone.jpeg', name: 'Phone'),
    PicCard(imagePath: 'assets/images/word-images/pig.jpeg', name: 'Pig'),
    PicCard(imagePath: 'assets/images/word-images/sheep.jpeg', name: 'Sheep'),
    PicCard(imagePath: 'assets/images/word-images/shoes.jpeg', name: 'Shoes'),
    PicCard(imagePath: 'assets/images/word-images/socks.jpeg', name: 'Socks'),
    PicCard(imagePath: 'assets/images/word-images/spoon.jpeg', name: 'Spoon'),
    PicCard(imagePath: 'assets/images/word-images/table.jpeg', name: 'Table'),
  ];

  final Random _random = Random();
  
  List<PicCard> getRandomCards(int count) {
    final shuffled = List<PicCard>.from(_allCards)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  PicCard getRandomCardFromList(List<PicCard> cards) {
    return cards[_random.nextInt(cards.length)];
  }
}