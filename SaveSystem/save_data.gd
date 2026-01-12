extends RefCounted

const SAVE_DATA : Array[StringName] = [&"player_location", &"abilities"]

var player_location : Vector2
var abilities : Dictionary[StringName, bool]


## Returns the [SaveData].
func get_data() -> Dictionary:
	var data : Dictionary[StringName, Variant]

	for property in SAVE_DATA:
		data[property] = get(property)

	return data


## Add every property to the [SaveData] object.
func set_data(data : Dictionary) -> void:
	if data.is_empty():
		return

	for property in SAVE_DATA:
		set(property, data[property])