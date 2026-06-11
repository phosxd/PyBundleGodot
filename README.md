<div align="middle">

<img src="./git_assets/icon.png" align=""></img>

**Version:** 0.0.1

PyBundleGodot is a tool for Godot 4.6 that makes it easy to efficiently bundle Python into your Godot project!

</div>

---

# Table of contents
- [Explanation](#explanation)
- [Platforms](#platforms)
- [Features](#features)


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


# Platforms
PyBundle can only be used on Linux, Windows, Mac, & Android.
Furthermore there is only a pre-built interpreter for Linux, you will need to compile the interpreter for other platforms yourself.


# Features

## Fully Featured 3.6 Interpreter
Access 

## Automatic Build Tools
Not happy with the current version of Python or need third-party libraries? Compile the interpreter on your own machine using Nuitka or PyInstaller & the pre-made Shell scripts.
Navigate to the Godot editor tools menu under "Project" to find the build buttons.

Keep in mind that the pre-made Shell scripts for building the interpreter only work on Linux systems, you can modify them for your platform if needed. If you do end up doing that, please do submit a PR so others do not need to go through the same process.


 
