run: build test
	@zig build run -- $(ARGS)

build:
	@zig build -freference-trace

test: build
	@zig build test