<div align="middle">

<img src="./git_assets/icon.png" align=""></img>

**Version:** 1.1.0

PyBundle is a tool for Godot 4.6 that makes it easy to efficiently bundle Python into your Godot project!

This project is very much work in progress & has a lot more that needs to be done, but for now it is workable.

</div>

---

# Table of contents
- [Explanation](#explanation)
- [Platforms](#platforms)
- [Features](#features)
  - [Works out of the box](#works-out-of-the-box-with-demos)
  - [Fully featured 3.6 interpreter](#fully-featured-36-interpreter)
  - [Automatic build tools](#automatic-build-tools)
- [Get Started](#get-started)


# Explanation
PyBundle does not provide an API for interacting with Godot objects. The focus of this project is to provide access to the Python ecosystem in a tiny & efficient package so that you can do things that were previously impossible in Godot without GDExtension (C++) or C#.
Game logic can be entirely handled with GDScript, so Python provides no benefit for that use case (except maybe for sandboxing purposes in modding, in which case you can set up your own API).

## Why use over GDExtension?

GDExtension can be difficult to set up if you aren't very knowledgable in that field. C++ is also static & cannot change or be added to during run-time, which is not a problem for interpreted languages like Python & GDScript.

Python is easy to learn, easy to set up, & has the advantage of not needing to be compiled.

## Why use over C#?

It's a whale, that's all. I don't have anything against it, I just don't like how large it is.
- PyBundle Python interpreter size (with all standard libraries): 4.5MB
- DotNet size (at least for me on Linux): 76MB

## Two plugins
PyBundleGodot comes with 2 separate plugins:

Firstly the actual "PyBundle" plugin which contains editor tools for compiling the interpreter, includes the `PyRunner` singleton for running Python scripts, & is also responsible for properly including the interpreter executable as well as your Python scripts when you export your project.

The second plugin is "BinBundle" which actually handles sub-process communication & running embedded executables, it comes with 2 nodes "SubProcess" & "BinBundleProcess".
"SubProcess" runs the sub-process & handles communication, while "BinBundleProcess" builds on top of that to automatically extract the correct platform-specific executable & run it through SubProcess.


---


# Platforms
PyBundle can only be used on Linux, Windows, Mac, & Android.
Furthermore there are only pre-built executables for Linux & Windows, you will need to compile the interpreter for other platforms (like Mac) yourself.


# Features

## Works out of the box with demos
No setup or configuration needed, you don't even need Python installed on your system, the interpreter comes bundled in.

Run the project to test out the embedded Python console demo! There is also a demo for testing your locally installed Python within Godot, which you can techinically use for your project but it requires that the user has the exact version of Python you need & the exact libraries you need as well.

Want to work from scripts instead of a console? There's a demo for that too! It uses the `PyRunner` singleton which takes a script path & that's it, very simple.

## Fully featured 3.14 interpreter
Access all standard libraries in Python 3.14.5 (except GUI packages like TkInter) all in a 4.5MB package (on Linux, is 10MB for Windows). Run & import any of your Python scripts like you would in normal Python.

## Automatic build tools
Not happy with the current version of Python or need third-party libraries? Compile the interpreter on your own machine using Nuitka & the pre-made Batch/Shell scripts.
Navigate to the Godot editor tools menu under "Project" to find the build buttons which will vary based on your platform.

Make sure you have [Nuitka](https://nuitka.net/) properly installed on your system before using the build tools, otherwise it may not work. By default PyBundle uses Visual Studio for the Nuitka C++ compilation on Windows, you can modify the build script to use the compiler of your choice by changing the `--msvc=latest` flag to another valid value listed in the [Nuitka docs](https://nuitka.net/user-documentation/user-manual.html)


# Get Started
Open up an IDE that is well suited for Python scripts, you technically can use Godot but it has no auto-completion or syntax highlighting for `.py` files.

Once you have an IDE of your choice all set up, create a test script in your Godot project's root directory (`res://`):
```python
# main.py
def main():
	print('Hello World')


if __name__ == 'main': main()
```

First test & make sure it works with your on-system Python installation.

After making sure the Python script is valid, we can move on to actually running it in Godot. For this, we need to create an [autoload singleton](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) script which will be used to interface with the `PyRunner` singleton provded by PyBundle.
In your newly created autoload (lets call `init.gd`), paste the following code:
```gdscript
# init.gd
extends Node


func _ready() -> void:
	PyRunner.output_received.connect(_on_output_received)
	PyRunner.error_received.connect(_on_error_received)
	PyRunner.stopped.connect(_on_stopped)
	PyRunner.start_entry_point('res://main.py')


func _on_output_received(data:String) -> void:
	print(data)


func _on_error_received(data:String) -> void:
	printerr(data)


func _on_stopped() -> void:
	printerr('Process stopped')
```

This is a simple boilerplate script with all the important signals connected. The `PyRunner.start_entry_point('res://main.py')` line is what actually runs your Python script, though keep in mind I recommend this only be run once & trying to call this function while `PyRunner.active` is `true` will print an error.

Now with this autoloaded script in place, when you run your project, the Python script will automatically start as a sub-process that will be killed when your project stops running.
