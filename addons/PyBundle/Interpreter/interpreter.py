# This is what all your Python scripts run through.
# Without importing any modules, only the standard Python modules can be used.
# Just import any library present on your system to include them in the next build.


# Main loop.

if __name__ == '__main__':
	while True:
		i:str = input()
		i = i.replace('(%new_line%)','\n')
		exec(i)
