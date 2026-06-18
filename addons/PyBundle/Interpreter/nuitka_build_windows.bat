cd addons/PyBundle/Interpreter/
python -m nuitka --remove-output --mode=onefile --lto=yes --python-flag=dont_write_bytecode --python-flag=no_docstrings --msvc=latest "interpreter.py"
