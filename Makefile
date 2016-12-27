all:
	swiftc -I. -L. -lpatterns -warnings-as-errors src/deasciifier.swift

patterns: src/patterns.swift
	swiftc -Onone src/patterns.swift -emit-module -emit-library

clean:
	rm deasciifier patterns.swiftmodule libpatterns.dylib
