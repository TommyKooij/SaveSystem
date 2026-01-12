extends RefCounted
class_name SaveSystem

## Each created save instance will be stored at this location.
const SaveData = preload("res://SaveSystem/save_data.gd")
# "user://save_data/"
const SAVE_PATH := "user://game_data/"

var save_data : SaveData
var data : Dictionary


## Creates an empty [SaveData] resource upon initialization.
func _init() -> void:
	set_save_data()


## ALERT: Currently this function does not work, as save_data is not an Dictionary.
## Stores the value inside the internal [SaveFile] dictionary.
func set_value(field : String, value : Variant) -> void:
	data[field] = value


## Retrieves the value from the internal [SaveFile] dictionary.
func get_value(field : String) -> Variant:
	return data.get(field)


## Returns a [Dictionary] containing all save data.
func get_save_data() -> Dictionary:
	return save_data.get_data()


## Initializes and loads [SaveData]. By default it is empty.
func set_save_data() -> void:
	save_data = SaveData.new()

	if data.is_empty():
		save_data.set_data({})
	else:
		save_data.set_data(data)


## Stores the save data of a Game object. Allows for easier storage of game data.
func store_game(Zhoyd) -> void:
	data["_Zhoyd_"] = Zhoyd.get_save_data()


## Retrieves save data of a Game object.
func retrieve_game(Zhoyd) -> void:
	var game_data : Dictionary = data.get("_Zhoyd_", {})
	Zhoyd.set_save_data(game_data)


## Creates a new [SaveFile] for the current running game instance.
## The [SaveFile] comes in the form of a text document.
func set_save_game(file_name : String) -> void:
	## Checks if the SAVE_PATH folder exists. If not, creates a [SaveFile] folder.
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_absolute(SAVE_PATH)

	## Creates and stores the [SaveFile] inside the SAVE_PATH folder.
	var SAVE_FILE_PATH := SAVE_PATH + file_name
	var file : FileAccess = _setup_save(SAVE_FILE_PATH)
	if not file:
		return
	file.store_string(var_to_str(data))


## Retrieve the required [SaveFile] from the save file folder.
func get_save_game(file_name : String) -> void:
	## Checks if the SAVE_PATH folder exists. If not, return.
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		return

	## Retrieves the [SaveFile] from the SAVE_PATH folder, only if it exists.
	var SAVE_FILE_PATH := SAVE_PATH + file_name
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file : FileAccess = _setup_load(SAVE_FILE_PATH)
		if not file:
			return

		var loaded_data = str_to_var(file.get_as_text())
		if not loaded_data is Dictionary:
			push_error("Failed to load text data from file \"%s\"!" % SAVE_FILE_PATH)
			return

		data = loaded_data


## Quick check to see if the required [SaveFile] exists.
func get_save_file(file_name : String) -> bool:
	if FileAccess.file_exists(SAVE_PATH + file_name):
		return true
	else:
		return false


## Checks if the [SaveFile] already exists. If it does, the data on the existing file is overwritten.
func _setup_save(path : String) -> FileAccess:
	data.merge(get_save_data())

	var file := FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_warning("Failed to write save file \"%s\"! Error: %d!" % [path, FileAccess.get_open_error()])
	return file


## Checks if the requested [SaveFile] already exists. If it does, return it.
func _setup_load(path : String) -> FileAccess:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_warning("Failed to load save file \"%s\"! Error: %d!" % [path, FileAccess.get_open_error()])
	return file