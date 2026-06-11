extends VBoxContainer

@export_file_path('*.py') var script_path:String = ''


func _ready() -> void:
	%SubProcess.arguments.append(ProjectSettings.globalize_path(script_path))
	%SubProcess.start()


func _on_input_text_submitted(new_text:String) -> void:
	%Input.text = ''
	%SubProcess.send_input(new_text)


func _on_sub_process_output_received(data:String) -> void:
	%Output.append_text(data+'\n')


func _on_sub_process_error_received(data:String) -> void:
	%Output.append_text(('[color=red]%s[/color]' % data) + '\n')


func _on_sub_process_stopped() -> void:
	%Output.append_text('[b][color=red]Process stopped.[/color][/b]\n')
