run: build
	@./zig-out/bin/aoc $(ARGS)

build: test
	@zig build -freference-trace

test: 
	@zig test src/root.zig