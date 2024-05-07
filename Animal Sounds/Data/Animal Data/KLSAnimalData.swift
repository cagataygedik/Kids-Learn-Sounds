//
//  AnimalData.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 6.05.2024.
//

import UIKit

struct KLSAnimalData {
    static let animals: [ASAnimal] = [
        ASAnimal(name: "Dog", image: UIImage(named: "dog") ?? UIImage(), soundFileName: "dog"),
        ASAnimal(name: "Cat", image: UIImage(named: "cat") ?? UIImage(), soundFileName: "cat"),
        ASAnimal(name: "Monkey", image: UIImage(named: "monkey") ?? UIImage(), soundFileName: "monkey"),
        ASAnimal(name: "Chicken", image: UIImage(named: "chicken") ?? UIImage(), soundFileName: "chicken"),
        ASAnimal(name: "Crab", image: UIImage(named: "crab") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Elephant", image: UIImage(named: "elephant") ?? UIImage(), soundFileName: "elephant"),
        ASAnimal(name: "Fox", image: UIImage(named: "fox") ?? UIImage(),soundFileName: ""),
        ASAnimal(name: "Frog", image: UIImage(named: "frog") ?? UIImage(), soundFileName: "frog"),
        ASAnimal(name: "Giraffe", image: UIImage(named: "giraffe") ?? UIImage(), soundFileName: "giraffe"),
        ASAnimal(name: "Hippo", image: UIImage(named: "hippo") ?? UIImage(), soundFileName: "hippo"),
        ASAnimal(name: "Horse", image: UIImage(named: "horse") ?? UIImage(), soundFileName: "horse"),
        ASAnimal(name: "Owl", image: UIImage(named: "owl") ?? UIImage(), soundFileName: "owl"),
        ASAnimal(name: "Bird", image: UIImage(named: "bird") ?? UIImage(), soundFileName: "bird"),
        ASAnimal(name: "Penguin", image: UIImage(named: "penguin") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Pig", image: UIImage(named: "pig") ?? UIImage(), soundFileName: "pig"),
        ASAnimal(name: "Rabbit", image: UIImage(named: "rabbit") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Shark", image: UIImage(named: "shark") ?? UIImage(), soundFileName: "shark"),
        ASAnimal(name: "Sheep", image: UIImage(named: "sheep") ?? UIImage(), soundFileName: "sheep"),
        ASAnimal(name: "Snake", image: UIImage(named: "snake") ?? UIImage(), soundFileName: "snake"),
        ASAnimal(name: "Spider", image: UIImage(named: "spider") ?? UIImage(), soundFileName: "spider"),
    ]
}
