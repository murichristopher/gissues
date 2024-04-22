start:
	@rm -rf gissues
	@mix escript.build > /dev/null 2>&1
	./gissues $(args)

tests:
	@mix test