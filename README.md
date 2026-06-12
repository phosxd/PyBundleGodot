<div align="middle">

<img src="./git_assets/icon.png" align=""></img>

**Version:** 1.0.0

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
Furthermore there is only a pre-built interpreter for Linux, you will need to compile the interpreter for other platforms yourself.


# Features

## Works out of the box with demos
No setup or configuration needed, you don't even need Python installed on your system, the interpreter comes bundled in if you are on Linux.

Run the project to test out the embedded Python console demo! There is also a demo for testing your locally installed Python within Godot, which you can techinically use for your project but it requires that the user has the exact version of Python you need & the exact libraries you need as well.

Want to work from scripts instead of a console? There's a demo for that too! It uses the `PyRunner` singleton which takes a script path & that's it, very simple.

## Fully featured 3.14 interpreter
Access all standard libraries in Python 3.14.5 (except GUI packages like TkInter) all in a 4.5MB package. Run & import any of your Python scripts like you would in normal Python.

## Automatic build tools
Not happy with the current version of Python or need third-party libraries? Compile the interpreter on your own machine using Nuitka or PyInstaller & the pre-made Shell scripts.
Navigate to the Godot editor tools menu under "Project" to find the build buttons.

**Nuitka VS PyInstaller:**
- Nuitka:
  - Smaller binary size.
- PyInstaller:
  - Slightly more memory efficient.

Keep in mind that the pre-made Shell scripts for building the interpreter only work on Linux systems, you can modify them for your platform if needed. If you do end up doing that, please do submit a PR so others do not need to go through the same process.


 
