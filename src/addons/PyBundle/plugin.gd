@tool
extends EditorPlugin

const pyrunner_path:String = 'res://addons/PyBundle/PyRunner.gd'
const interpreter_script_name:String = 'interpreter.py'
const build_script_names:PackedStringArray = [
	'nuitka_build.sh',
	'pyinstaller_build.sh',
]
const start_binary_name:String = 'interpreter.bin'
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
	sub.path = 'bash'
	sub.arguments = [proj_root+build_script_names.get(mode)]

	sub.output_received.connect(func(data:String) -> void:
		print(data)
	)
	sub.error_received.connect(func(data:String) -> void:
		print_rich('[color=yellow]%s[/color]' % data)
	)
	sub.stopped.connect(func() -> void:
		sub.queue_free()
		# Rename binary.
		var new_binary_name = get_platform_extension().trim_prefix('.')+'.bin'
		DirAccess.rename_absolute(proj_root+start_binary_name, proj_root+new_binary_name)
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
