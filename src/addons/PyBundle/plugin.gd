@tool
extends EditorPlugin

const pyrunner_path:String = 'res://addons/PyBundle/PyRunner.gd'
const interpreter_script_name:String = 'interpreter.py'
const build_script_names:Dictionary[String,PackedStringArray] = {
	'linux': [
		'nuitka_build_linux.sh',
		'pyinstaller_build_linux.sh',
	],
	'windows': [
		'nuitka_build_windows.bat',
		'pyinstaller_build_windows.bat',
	],
}
const start_binary_name:String = 'interpreter'
var proj_root:String = ProjectSettings.globalize_path('res://addons/PyBundle/Interpreter/')

var export_plugin:EditorExportPlugin = preload('res://addons/PyBundle/export.gd').new()


func _enter_tree() -> void:
	add_export_plugin(export_plugin)
	add_tool_menu_item('Build Python Interpreter (Nuitka)', _build_py.bind(0))
	add_tool_menu_item('Build Python Interpreter (PyInstaller)', _build_py.bind(1))


func _exit_tree() -> void:
	remove_export_plugin(export_plugin)
	remove_tool_menu_item('Build Python Interpreter (Nuitka)')
	remove_tool_menu_item('Build Python Interpreter (PyInstaller)')


func _enable_plugin() -> void:
	add_autoload_singleton('PyRunner', pyrunner_path)


func _disable_plugin() -> void:
	remove_autoload_singleton('PyRunner')


func _build_py(mode:int) -> void:
	print_rich('\n[b]Starting Python build process (%s)...[/b]\n' % 'Nuitka' if mode == 0 else 'PyInstaller')
	var sub = SubProcess.new()

	var platform:String = OS.get_name()
	if platform == 'Linux' or platform.ends_with('BSD'):
		sub.path = 'bash'
		sub.arguments = [proj_root+build_script_names.linux.get(mode)]
	elif platform == 'Windows':
		sub.path = proj_root+build_script_names.windows.get(mode)
	else:
		printerr('Automatic building only supported on Linux or Windows. Sorry not sorry, Mac.')
		return

	sub.output_received.connect(func(data:String) -> void:
		print(data)
	)
	sub.error_received.connect(func(data:String) -> void:
		print_rich('[color=yellow]%s[/color]' % data)
	)

	sub.stopped.connect(func() -> void:
		sub.queue_free()
		# Rename binary.
		var platform_exe_extension:String
		if platform == 'Windows': platform_exe_extension = 'exe'
		else: platform_exe_extension = 'bin'
		var new_binary_name = get_platform_extension().trim_prefix('.')+'.%s' % platform_exe_extension
		DirAccess.rename_absolute(proj_root+start_binary_name+'.%s' % platform_exe_extension, proj_root+new_binary_name)

		if platform == 'Windows':
			if mode == 1: DirAccess.rename_absolute(proj_root+'dist/'+start_binary_name+'.exe', proj_root+new_binary_name)
			print('\nOn Windows, you need to manually remove the left-over directories & files (*.dist, *.build, *.onefile-build, dist, build, *.spec). The only things that should be left are binary/exe files, Python files, batch/shell files, & a markdown file.')

		print_rich('[b]Done.[/b]')
	)

	sub.start()


func get_platform_extension() -> String:
	var platform:String = OS.get_name()
	var architecture:String = Engine.get_architecture_name()

	var extension:String = ''
	if platform == 'Linux' or platform.ends_with('BSD'): extension = '.linux'
	elif platform == 'Windows': extension = '.windows'
	elif platform == 'macOS': extension = '.mac'
	else: extension = '.other'

	extension += '.'+architecture
	return extension
