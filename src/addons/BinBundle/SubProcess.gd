## Run a sub-process with I/O & error pipes.
##
## Call [member start] to begin the sub-process.
class_name SubProcess extends Node

## Emitted when the sub-process has started running.
signal started
## Emitted when the sub-process has stopped running.
signal stopped
## Emitted when an error occurs.
signal error_received(data:String)
## Emitted when output is reveived.
signal output_received(data:String)

@export var path:String = ''
@export var arguments:PackedStringArray = []

## If [code]true[/code], the sub-process will be terminated when the Node exits the tree.
## Otherwise it will continue running well after the main process has stopped.
@export var autostop:bool = true
## Time in seconds between each sub-process output check.
## [br] This has little to no performance impact.
@export var output_poll_interval:float = 1.0
## Time in seconds between each sub-process error check.
## [br] This has little to no performance impact.
@export var error_poll_interval:float = 1.0

## Process input/output pipe.
var io_access: FileAccess
## Process error pipe.
var error_access: FileAccess
## Process ID.
var pid: int

var output_thread := Thread.new()
var error_thread := Thread.new()

## Is [code]true[/code] when the sub-process is running.
var active:bool = false


func _exit_tree() -> void:
	if autostop: stop()


## Starts the sub-process then opens new [member io_access] & [member error_access] with a unique [member pid].
func start() -> void:
	if active: return

	var bridge:Dictionary = OS.execute_with_pipe(path, arguments, false)
	if bridge.is_empty():
		printerr('Unable to start sub-process.')
		error_received.emit('CannotStart')
		return

	io_access = bridge.stdio
	error_access = bridge.stderr
	pid = bridge.pid

	# Start output & error listener threads.
	output_thread.start(_output_listener)
	error_thread.start(_error_listener)

	active = true
	started.emit()


## Kills the sub-process.
func stop() -> void:
	# Stop listener threads.
	output_thread.set_meta('canceled', true)
	error_thread.set_meta('canceled', true)
	output_thread.wait_to_finish()
	error_thread.wait_to_finish()
	# Kill sub-process.
	OS.kill(pid)
	active = false
	stopped.emit()


## Send [param data] to the sub-process.
## [br] Use [member output_recieved] to listen for a response.
func send_input(data:String) -> void:
	if not active: return

	io_access.store_line(data)

	var err:Error = io_access.get_error()
	if err != OK: error_received.emit(error_string(err))


# Check for output every `output_poll_interval` seconds.
func _output_listener() -> void:
	while output_thread.get_meta('canceled',false) == false:
		OS.delay_msec(int(output_poll_interval*1000))
		if not OS.is_process_running(pid):
			stop.call_deferred()
			break
		if io_access.get_length() == 0: continue

		# Emit output data.
		var output:String = io_access.get_line()
		output_received.emit.call_deferred(output)


# Check for error every `error_poll_interval` seconds.
func _error_listener() -> void:
	while error_thread.get_meta('canceled',false) == false:
		OS.delay_msec(int(error_poll_interval*1000))
		if error_access.get_length() == 0: continue

		# Get error message.
		var message:String = error_access.get_line()
		while error_access.get_length() > 0:
			message += '\n'+error_access.get_line()

		# Emit error.
		error_received.emit.call_deferred(message)
