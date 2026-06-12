extends VBoxContainer


func _ready() -> void:
	PyRunner.output_received.connect(_on_sub_process_output_received)
	PyRunner.error_received.connect(_on_sub_process_error_received)
	PyRunner.stopped.connect(_on_sub_process_stopped)


func _on_input_text_submitted(new_text:String) -> void:
	%Input.text = ''
	if PyRunner.active: return
	PyRunner.start_entry_point(new_text)


func _on_sub_process_output_received(data:String) -> void:
	%Output.append_text(data+'\n')


func _on_sub_process_error_received(data:String) -> void:
	%Output.append_text(('[color=red]%s[/color]' % data) + '\n')


func _on_bundle_error_revieved(code:BinBundleProcess.BinBundleError, args:Array) -> void:
	%Output.append_text(('[color=red]%s:[/color] %s' % [code,args]) + '\n')


func _on_sub_process_stopped() -> void:
	%Output.append_text('[b][color=red]Process stopped.[/color][/b]\n')
