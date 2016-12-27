all:
	swiftc -O -I. -L. -lpatterns -warnings-as-errors src/deasciifier.swift

patterns: src/patterns.swift
	swiftc -Onone src/patterns.swift -emit-module -emit-library

clean:
	rm deasciifier
