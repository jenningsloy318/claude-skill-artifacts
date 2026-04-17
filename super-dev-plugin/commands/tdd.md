<meta>
  <name>tdd</name>
  <type>command</type>
  <description>Enforce test-driven development workflow with scaffold interfaces, tests FIRST, then minimal implementation to pass</description>
</meta>

<purpose>Invoke the tdd-guide agent to enforce test-driven development methodology. Scaffold interfaces, generate tests FIRST, then implement minimal code to pass. Ensure 80%+ coverage.</purpose>

<usage>/super-dev:tdd [feature or function to implement]</usage>

<process>
  <step n="1" name="Write Test (RED)">Start with a failing test that describes expected behavior</step>
  <step n="2" name="Verify Fails">Run test suite to confirm the test fails</step>
  <step n="3" name="Implement (GREEN)">Write minimum code to make the test pass</step>
  <step n="4" name="Verify Passes">Run test suite to confirm pass</step>
  <step n="5" name="Refactor (IMPROVE)">Remove duplication, improve names, optimize</step>
  <step n="6" name="Check Coverage">Verify 80%+ coverage across branches, functions, lines, statements</step>
</process>

<constraints>
  <constraint>Tests BEFORE code — no code without tests</constraint>
  <constraint>All public functions must have unit tests</constraint>
  <constraint>All API endpoints must have integration tests</constraint>
  <constraint>Critical flows must have E2E tests</constraint>
  <constraint>Coverage must be 80%+ (branches, functions, lines, statements)</constraint>
  <constraint>Edge cases covered: null, empty, invalid types, boundaries, errors, race conditions</constraint>
</constraints>
