//
//  AnimalData.swift
//  Animal Sounds
//
//  Created by Celil Çağatay Gedik on 6.05.2024.
//

import UIKit

struct KLSAnimalData {
    static let animals: [KLSAnimal] = [
        KLSAnimal(name: "Dog", image: UIImage(named: "dog") ?? UIImage(), soundFileName: "dog"),
        KLSAnimal(name: "Cat", image: UIImage(named: "cat") ?? UIImage(), soundFileName: "cat"),
        KLSAnimal(name: "Monkey", image: UIImage(named: "monkey") ?? UIImage(), soundFileName: "monkey"),
        KLSAnimal(name: "Chicken", image: UIImage(named: "chicken") ?? UIImage(), soundFileName: "chicken"),
        KLSAnimal(name: "Crab", image: UIImage(named: "crab") ?? UIImage(), soundFileName: ""),
        KLSAnimal(name: "Elephant", image: UIImage(named: "elephant") ?? UIImage(), soundFileName: "elephant"),
        KLSAnimal(name: "Fox", image: UIImage(named: "fox") ?? UIImage(),soundFileName: ""),
        KLSAnimal(name: "Frog", image: UIImage(named: "frog") ?? UIImage(), soundFileName: "frog"),
        KLSAnimal(name: "Giraffe", image: UIImage(named: "giraffe") ?? UIImage(), soundFileName: "giraffe"),
        KLSAnimal(name: "Hippo", image: UIImage(named: "hippo") ?? UIImage(), soundFileName: "hippo"),
        KLSAnimal(name: "Horse", image: UIImage(named: "horse") ?? UIImage(), soundFileName: "horse"),
        KLSAnimal(name: "Owl", image: UIImage(named: "owl") ?? UIImage(), soundFileName: "owl"),
        KLSAnimal(name: "Bird", image: UIImage(named: "bird") ?? UIImage(), soundFileName: "bird"),
        KLSAnimal(name: "Penguin", image: UIImage(named: "penguin") ?? UIImage(), soundFileName: ""),
        KLSAnimal(name: "Pig", image: UIImage(named: "pig") ?? UIImage(), soundFileName: "pig"),
        KLSAnimal(name: "Rabbit", image: UIImage(named: "rabbit") ?? UIImage(), soundFileName: ""),
        KLSAnimal(name: "Shark", image: UIImage(named: "shark") ?? UIImage(), soundFileName: "shark"),
        KLSAnimal(name: "Sheep", image: UIImage(named: "sheep") ?? UIImage(), soundFileName: "sheep"),
        KLSAnimal(name: "Snake", image: UIImage(named: "snake") ?? UIImage(), soundFileName: "snake"),
        KLSAnimal(name: "Spider", image: UIImage(named: "spider") ?? UIImage(), soundFileName: "spider"),
    ]
}
