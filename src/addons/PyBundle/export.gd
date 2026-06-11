extends EditorExportPlugin


func _export_begin(features:PackedStringArray, is_debug:bool, _path:String, flags:int) -> void:
	# Add interpreter.
	for path:String in DirAccess.get_files_at('res://addons/PyBundle/Interpreter'):
		if path.get_extension() not in ['x86_64','x86_32','arm64','arm32']: continue
		add_file(path, FileAccess.get_file_as_bytes(path), false)

	# Add Python scripts.
	walk_dir('res://', func(script_path:String) -> void:
		if script_path.get_extension() != 'py': return
		add_file(script_path, FileAccess.get_file_as_bytes(script_path), false)
	)


## Iterates on every file & direcotry in the tree, starting from [param root_path].
func walk_dir(root_path:String, file_callback:Callable, dir_callback:=Callable()) -> void:
	root_path += '' if root_path.ends_with('/') else '/'
	var dir := DirAccess.open(root_path)
	if not dir: return
	dir.list_dir_begin()

	while true:
		var path:String = dir.get_next()
		var is_dir:bool = dir.current_is_dir()
		if path.is_empty(): break
		if is_dir:
			if dir_callback && dir_callback.get_argument_count() == 1: dir_callback.call(path)
			walk_dir(root_path+path, file_callback, dir_callback)
		elif file_callback && file_callback.get_argument_count() == 1:
			file_callback.call(root_path+path)

	dir.list_dir_end()
