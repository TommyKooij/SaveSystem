# SaveSystem
An easy-to-use save system build for the Godot game engine. This system is based on a similar system used by KoBeWi's [Metroidvania System](https://github.com/KoBeWi/Metroidvania-System). While it is mainly used for metroidvania, it can be sued for other kinds of games as well.

Support Godot **4.5** or newer.

## Overview
This system allows for easy and quick save/load of games. Creating and implementing a save system can be tedious and time consuming, which is why I build a system that simplifies that concept and that can be used by others as well.

The SaveSystem, upon saving, creates a new directory called save_folder inside the User folder. It then stores the file inside the save_folder, where it can be retrieved from later at another point inside your project. Inside this save file you can store different types of data, like: abilities, player location, and game events. These types of data can then be retrieved and assigned respectively upon starting the game. If a file with the same name already exists, the information inside it will automatically be overwritten with the new data.

It is also possible to create/load different save files, but managing them might be a bit tricky.


## Instructions
### Saving
To create a save file with the SaveSystem, either create a Save Point that your Player can interact with or a script that registers certain button inputs. Once that is done, we first need to preload the SaveSystem and create a variable that holds the instance of our system. 
```gdscript
const SaveManager = preload("res://globals/manager/save_manager.gd")
var save_manager : SaveManager

func _get_save_game() -> void:
	save_manager = SaveManager.new()
```
After that, I recommend creating a different function wherein you post all the data you want to save. 
```gdscript
const SaveManager = preload("res://globals/manager/save_manager.gd")
var save_manager : SaveManager

func _get_save_game() -> void:
	save_manager = SaveManager.new()

func save_game() -> void:
	save_manager.set_value("abilities", player.abilities)
	save_manager.set_value("player_location", player.global_position)
	save_manager.set_save_game(save_path)
```
You can then call this function whenever you want to save your game.

### Loading
To load a save file with the SaveSystem, similar to when you create a save file with the SaveSystem, you need to create an instance of the SaveSystem class. After that is done, we need to fetch the save file from the save_file folder. For clarity sake, I recommend making an unique function and assign the fetched save file to the save_file variable you just created. 
```gdscript
const SaveManager = preload("res://globals/manager/save_manager.gd")
var save_manager : SaveManager

func _get_save_game() -> void:
	save_manager = SaveManager.new()

    var save_file = save_manager.get_save_file(save_path)
```
When the fetching is done, you can assign the data to objects inside your game.
```gdscript
const SaveManager = preload("res://globals/manager/save_manager.gd")
var save_manager : SaveManager

func _get_save_game() -> void:
	save_manager = SaveManager.new()

    var save_file = save_manager.get_save_file(save_path)
	if save_file == true:
		save_manager.get_save_game(save_path)
		# Assign loaded values.
		player.abilities.assign(save_manager.get_value("abilities"))
        player.location.assign(save_manager.get_value("player_location"))
	else:
		save_manager.set_save_data()
```
