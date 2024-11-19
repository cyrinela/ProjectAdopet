import '../models/dog.dart';
import '../models/Owner.dart';


Owner owner = Owner(
  name: "Spikey Sanju",
  bio: "Developer & Pet Lover",
  image: "assets/owner.jpg", 
);

List<Dog> dogList = [
  Dog(
    id: 0,
    name: "Hachiko",
    age: 3.5,
    gender: "Male",
    color: "Brown",
    weight: 12.9,
    location: "389m away",
    image: "assets/orange_dog.png", 
    about:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.",
    owner: owner, 
  ),
  Dog(
    id: 1,
    name: "Skooby Doo",
    age: 3.5,
    gender: "Male",
    color: "Gold",
    weight: 12.4,
    location: "412m away",
    image: "assets/blue_dog.png", 
    about:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.",
    owner: owner,
  ),
  Dog(
    id: 2,
    name: "Miss Agnes",
    age: 3.5,
    gender: "Female",
    color: "White",
    weight: 9.6,
    location: "879m away",
    image: "assets/red_dog.png", 
    about:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.",
    owner: owner,
  ),
  Dog(
    id: 3,
    name: "Cyrus",
    age: 3.5,
    gender: "Male",
    color: "Black",
    weight: 8.2,
    location: "672m away",
    image: "assets/yellow_dog.png", 
    about:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.",
    owner: owner,
  ),
  Dog(
    id: 4,
    name: "Shelby",
    age: 3.5,
    gender: "Female",
    color: "Choco",
    weight: 14.9,
    location: "982m away",
    image: "assets/white_dog.png",
    about:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries.",
    owner: owner,
  ),
];
