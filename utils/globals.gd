class_name Globals
extends Object

enum Tone
{
	A,
	B,
	C,
	D,
	E,
	F,
	G,
}

enum ToneFlags
{
	A = 1,
	B = 2,
	C = 4,
	D = 8,
	E = 16,
	F = 32,
	G = 64,
}

const tone_color: Array[Color] = [
	Color(1, 0, 0),
	Color(1, 0.5, 0),
	Color(1, 1, 0),
	Color(0, 1, 0),
	Color(0, 1, 1),
	Color(0, 0.5, 1),
	Color(1, 0, 1),
]

static func get_action_from_tone(tone: Tone) -> String:
	return Tone.keys()[tone] + "_note"

static func get_resources(res_dir: DirAccess) -> Array[Resource]:
	var res: Array[Resource] = []
	var file_paths = res_dir.get_files()

	for path in file_paths:
		if path.ends_with(".tres"):
			var abs_path = res_dir.get_current_dir() + "/" + path
			res.append(load(abs_path))

	return res
