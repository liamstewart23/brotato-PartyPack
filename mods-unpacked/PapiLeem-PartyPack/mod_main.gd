extends Node

const MOD_DIR = "PapiLeem-PartyPack"

var mod_dir_path := ""
var item_extensions_dir_path := ""
var weapon_extensions_dir_path := ""

var item_files = []
var weapon_files = []

func _init():
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(MOD_DIR)
	item_extensions_dir_path = mod_dir_path.plus_file("content/items")
	weapon_extensions_dir_path = mod_dir_path.plus_file("content/weapons")

func _ready() -> void:
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	
	# Load items
	item_files = get_files_in_subdirs(item_extensions_dir_path)
	for item_path in item_files:
		ContentLoader.load_data(item_path, MOD_DIR)
	
	# Load weapons
	weapon_files = get_files_in_subdirs(weapon_extensions_dir_path)
	for weapon_path in weapon_files:
		ContentLoader.load_data(weapon_path, MOD_DIR)


# Helper function to get the .tres file from each subdirectory
func get_files_in_subdirs(base_dir_path: String) -> Array:
	var files = []
	var dir = Directory.new()

	if dir.open(base_dir_path) != OK:
		print("Cannot open directory: ", base_dir_path)
		return files

	dir.list_dir_begin()
	var name = dir.get_next()
	while name != "":
		if dir.current_is_dir() and name != "." and name != "..":
			var path = base_dir_path.plus_file(name).plus_file(name + "_item.tres")
			if dir.file_exists(path):
				files.append(path)
			else:
				print("No .tres file for ", name, " at ", path)
		name = dir.get_next()
	dir.list_dir_end()

	return files

