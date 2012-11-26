makeSpiedOn := method (
	x := Object clone
	x fooCalled := false
	x foo := method(self fooCalled := true)
	x
)
describe("Spies",
	it("should forward messages by default",
		spiedOn := makeSpiedOn
		spy := spyFor(spiedOn)
		spy foo
		expect(spiedOn fooCalled) toEqual(true)
	),

	it("should record calls",
		spiedOn := makeSpiedOn
		spy := spyFor(spiedOn)
		spy foo(1, 2)
		spy foo("a", "b")
		expect(spy calls at("foo")) toEqual(list(list(1, 2), list("a", "b")))
	)
)
