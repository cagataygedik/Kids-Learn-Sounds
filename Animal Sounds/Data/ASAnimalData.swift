//
//  AnimalData.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 6.05.2024.
//

import UIKit

struct ASAnimalData {
    static let animals: [ASAnimal] = [
        ASAnimal(name: "Dog", image: UIImage(named: "dog") ?? UIImage(), soundFileName: "dog"),
        ASAnimal(name: "Cat", image: UIImage(named: "cat") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Monkey", image: UIImage(named: "monkey") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Chicken", image: UIImage(named: "chicken") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Crab", image: UIImage(named: "crab") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Elephant", image: UIImage(named: "elephant") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Fox", image: UIImage(named: "fox") ?? UIImage(),soundFileName: ""),
        ASAnimal(name: "Frog", image: UIImage(named: "frog") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Giraffe", image: UIImage(named: "giraffe") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Hippo", image: UIImage(named: "hippo") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Horse", image: UIImage(named: "horse") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Owl", image: UIImage(named: "owl") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Bird", image: UIImage(named: "bird") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Penguin", image: UIImage(named: "penguin") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Pig", image: UIImage(named: "pig") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Rabbit", image: UIImage(named: "rabbit") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Shark", image: UIImage(named: "shark") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Sheep", image: UIImage(named: "sheep") ?? UIImage(), soundFileName: "sheep"),
        ASAnimal(name: "Snake", image: UIImage(named: "snake") ?? UIImage(), soundFileName: ""),
        ASAnimal(name: "Spider", image: UIImage(named: "spider") ?? UIImage(), soundFileName: ""),
    ]
}
