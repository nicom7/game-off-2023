@tool
extends EditorPlugin

func _enter_tree():
	updateVersion()

func _build():
	updateVersion()
	return true

func updateVersion():
	var output: Array = []
	var exit_code: int = OS.execute("git", ["describe", "--long", "--always"], output)
#	print("exit code: ", exit_code, " output: ", output)

	if exit_code == 0 and !output.is_empty():
		var version = (output[0] as String).trim_suffix("\n")

		var config = ConfigFile.new()
		config.set_value("application", "config/version", version)

		config.save("res://version.cfg")

		var short_version: PackedStringArray = version.split("-")
		if short_version.size() <= 1:
			# Found SHA only, default to 0.0.0
			short_version.clear()
			short_version.append("0.0.0")

		short_version[0] += ".0"
		config = ConfigFile.new()
		config.load("res://export_presets.cfg")

		config.set_value("preset.0.options", "application/file_version", short_version[0])
		config.set_value("preset.0.options", "application/product_version", short_version[0])

		config.save("res://export_presets.cfg")

#		print("version: ", version)
