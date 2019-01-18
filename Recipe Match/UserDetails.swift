//
//  UserDetails.swift
//  Recipe Match
//
//  Created by Karan Jaisingh on 6/25/18.
//  Copyright © 2018 KaranJaisinghOrg. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class UserDetails {
    
    var name: String = ""
    var email: String = ""
    var dietPreference: String = ""
    var dietRestriction: String = ""
    var madeDish: MadeDish? = nil
    var savedDish: Dish? = nil
    
    // constructor to initilaize user details
    init(userEmail: String, userID: String) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Users/\(userID)")
        print(ref)
        // saving key details locally
        email = userEmail
        let defaults = UserDefaults.standard
        if let nameString = defaults.string(forKey: defaultsKeys.keyTwo) {
            name = nameString
        }
        if let dietPreferenceString = defaults.string(forKey: defaultsKeys.keyThree) {
            print(dietPreferenceString)
            dietPreference = dietPreferenceString
        }
        if let dietRestrictionString = defaults.string(forKey: defaultsKeys.keyFour) {
            print(dietRestrictionString)
            dietRestriction = dietRestrictionString
        }
        
    }
    
    // function to update user details to database
    func updateProfileDetails(userID: String) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Users/\(userID)/Name").setValue(name)
        ref.child("Users/\(userID)/Email").setValue(email)
        ref.child("Users/\(userID)/DietPreference").setValue(dietPreference)
        ref.child("Users/\(userID)/DietRestriction").setValue(dietRestriction)
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: defaultsKeys.keyOne)
        defaults.set(name, forKey: defaultsKeys.keyTwo)
        defaults.set(dietPreference, forKey: defaultsKeys.keyThree)
        defaults.set(dietRestriction, forKey: defaultsKeys.keyFour)
        
    }
    
    // function to retrieve 'name' field
    func getName()->String {
        return name
    }
    
    // function to retrieve 'email' field
    func getEmail()->String {
        return email
    }
    
    // function to retrieve 'dietPreference' field
    func getDietPreference()->String {
        return dietPreference
    }
    
    // function to retrieve 'dietRestriction' field
    func getDietRestriction()->String {
        return dietRestriction
    }
    
    // function to retrieve 'madeDish' field
    func getMadeDish()->MadeDish {
        return madeDish!
    }
    
    // function to retrieve 'savedDish' field
    func getSavedDish()->Dish {
        return savedDish!
    }
    
    // function to modify 'name' field
    func setName(newName: String) {
        name = newName
    }
    
    // function to modify 'email' field
    func setEmail(newEmail: String) {
        email = newEmail
    }
    
    // function to modify 'dietPreference' field
    func setDietPreference(newDietPreference: String) {
        dietPreference = newDietPreference
    }
    
    // function to modify 'dietReference' field
    func setDietRestriction(newDietRestriction: String) {
        dietRestriction = newDietRestriction
    }
    
    // function to modify 'madeDish' field
    func setMadeDish(newDish: MadeDish) {
        madeDish = newDish
        sendMadeDish()
    }
    
    // function to modify 'savedDish' field
    func setSavedDish(newDish: Dish) {
        savedDish = newDish
        sendSavedDish()
    }
    
    // function to add new made dish to database
    func sendMadeDish() {
        
        print("Sending made dish!")
        let user = Auth.auth().currentUser;
        let uid = user?.uid
        
        let databaseRef = Database.database().reference().child("Users").child("\(uid!)").child("MadeDishes")
        
        let name = madeDish?.getName() ?? ""
        let numServings = madeDish?.getNumServings() ?? 0
        let recipeURL = madeDish?.getRecipeURL() ?? ""
        let imageURL = madeDish?.getImageURL() ?? ""
        let category = madeDish?.getCalories() ?? 0
        let ingredients = madeDish?.getIngredients() ?? [String]()
        let preferences = madeDish?.getDietPreferences() ?? [String]()
        let restrictions = madeDish?.getDietRestrictions() ?? [String]()
        let day = madeDish?.getDay() ?? 0
        let month = madeDish?.getMonth() ?? 0
        let year = madeDish?.getYear() ?? 0
        
        let madeDishDictionary = [
            "Name": name,
            "Number of Servings": numServings,
            "Recipe URL": recipeURL,
            "Image URL": imageURL,
            "Calories": category,
            "Ingredients": ingredients,
            "Diet Preferences": preferences,
            "Diet Restrictions": restrictions,
            "Day": day,
            "Month": month,
            "Year": year
            ] as [String : Any]
        
        databaseRef.childByAutoId().setValue(madeDishDictionary) {
            (error, ref) in
            if let errorx = error{
                print(errorx)
            } else {
                print("Successfully made dish!")
            }
        }

        madeDish = nil
    }
    
    // function to add new saved dish to database
    func sendSavedDish() {
        
        print("Sending saved dish!")
        
        let user = Auth.auth().currentUser;
        let uid = user?.uid
        
        let databaseRef = Database.database().reference().child("Users").child("\(uid!)").child("SavedDishes")
        
        let name = savedDish?.getName() ?? ""
        let numServings = savedDish?.getNumServings() ?? 0
        let recipeURL = savedDish?.getRecipeURL() ?? ""
        let imageURL = savedDish?.getImageURL() ?? ""
        let category = savedDish?.getCalories() ?? 0
        let ingredients = savedDish?.getIngredients() ?? [String]()
        let preferences = savedDish?.getDietPreferences() ?? [String]()
        let restrictions = savedDish?.getDietRestrictions() ?? [String]()
        let savedDishDictionary = [
            "Name": name,
            "Number of Servings": numServings,
            "Recipe URL": recipeURL,
            "Image URL": imageURL,
            "Calories": category,
            "Ingredients": ingredients,
            "Diet Preferences": preferences,
            "Diet Restrictions": restrictions
            ] as [String : Any]
        
        databaseRef.childByAutoId().setValue(savedDishDictionary) {
            (error, ref) in
            if let errorx = error{
                print(errorx)
            } else {
                print("Successfully saved dish!")
            }
        }
        savedDish = nil
    }
    
}
