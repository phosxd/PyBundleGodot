import example_module as example


# This will be called when run as entry point via PyRunner.
def main():
	example.hello_world()


# This will not execute when run as entry point via PyRunner.
if __name__ == '__main': main()
