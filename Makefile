patterns: src/patterns.swift
	swiftc -Onone src/patterns.swift -emit-library -emit-module

all:
	swiftc -I. -L. -lpatterns -warnings-as-errors src/deasciifier.swift

clean:
	rm deasciifier
