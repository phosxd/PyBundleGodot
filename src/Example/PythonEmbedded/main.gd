extends VBoxContainer


func _ready() -> void:
	%BinBundleProcess.start()


func _on_input_text_submitted(new_text:String) -> void:
	%Input.text = ''
	%BinBundleProcess.send_input(new_text)


func _on_sub_process_output_received(data:String) -> void:
	%Output.append_text(data+'\n')


func _on_sub_process_error_received(data:String) -> void:
	%Output.append_text(('[color=red]%s[/color]' % data) + '\n')


func _on_bundle_error_revieved(code:BinBundleProcess.BinBundleError, args:Array) -> void:
	%Output.append_text(('[color=red]%s:[/color] %s' % [code,args]) + '\n')


func _on_sub_process_stopped() -> void:
	%Output.append_text('[b][color=red]Process stopped.[/color][/b]\n')
