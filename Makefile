all:
	swiftc -I. -L. -lpatterns -warnings-as-errors src/deasciifier.swift

patterns: src/patterns.swift
	swiftc -Onone src/patterns.swift -emit-library -emit-module

clean:
	rm deasciifier
