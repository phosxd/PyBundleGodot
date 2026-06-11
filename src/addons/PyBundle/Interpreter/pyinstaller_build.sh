cd addons/PyBundle/Interpreter/
pyinstaller --onefile "interpreter.py"
mv dist/interpreter interpreter.bin
rm -rf build
rm -rf dist
rm interpreter.spec
