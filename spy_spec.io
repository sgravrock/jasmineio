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
	),

	it("should not forward intercepted calls to the target",
		spiedOn := makeSpiedOn
		spy := spyFor(spiedOn)
		spy intercept("foo")
		spy foo(1, 2)
		// The call should not have been forwarded.
		ignored := expect(spiedOn fooCalled) toEqual(false)
		// But it should have been recorded.
		expect(spy calls at("foo")) toEqual(list(list(1, 2)))
	),

	it("should forward calls to another object if andForwardTo is called",
		spiedOn := makeSpiedOn
		other := makeSpiedOn
		spy := spyFor(spiedOn)
		spy intercept("foo") andForwardTo(other)
		spy foo(1, 2)
		ignored := expect(spiedOn fooCalled) toEqual(false)
		ignored := expect(other fooCalled) toEqual(true)
		expect(spy calls at("foo")) toEqual(list(list(1, 2)))
	),

	it("should forward calls to a block if andCallFake is called",
		spiedOn := makeSpiedOn
		other := makeSpiedOn
		spy := spyFor(spiedOn)
		fakeCalled := false
		spy intercept("foo") andCallFake(block(
			fakeCalled = true
		))
		spy foo(1, 2)
		ignored := expect(spiedOn fooCalled) toEqual(false)
		ignored := expect(fakeCalled) toEqual(true)
		expect(spy calls at("foo")) toEqual(list(list(1, 2)))
	)
)
