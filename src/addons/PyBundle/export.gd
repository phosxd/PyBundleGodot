extends EditorExportPlugin

const interpreter_dir:String = 'res://addons/PyBundle/Interpreter/'


func _export_begin(features:PackedStringArray, is_debug:bool, _path:String, flags:int) -> void:
	# Add interpreter.
	for path:String in DirAccess.get_files_at(interpreter_dir):
		if path.get_extension() != 'bin': continue
		add_file(interpreter_dir+path, FileAccess.get_file_as_bytes(interpreter_dir+path), false)

	# Add Python scripts.
	PyBundleUtil.walk_dir('res://', func(script_path:String) -> void:
		if script_path.get_extension() != 'py': return
		add_file(script_path, FileAccess.get_file_as_bytes(script_path), false)
	)
