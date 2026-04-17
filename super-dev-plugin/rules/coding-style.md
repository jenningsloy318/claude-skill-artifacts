<meta>
  <name>coding-style</name>
  <type>rule</type>
  <description>Coding style rules for immutability, file organization, error handling, and input validation</description>
</meta>

<purpose>Enforce coding style standards: immutability, file organization, comprehensive error handling, input validation, and code quality.</purpose>

<directives>
  <directive severity="critical" name="Immutability">ALWAYS create new objects, NEVER mutate. Use spread operator (`{...obj, key: value}`) for updates.</directive>
  <directive severity="high" name="File Organization">Many small files over few large files. 200-400 lines typical, 800 max. Extract utilities from large components. Organize by feature/domain, not by type.</directive>
  <directive severity="high" name="Error Handling">ALWAYS handle errors comprehensively with try/catch. Log errors with context. Throw user-friendly error messages.</directive>
  <directive severity="high" name="Input Validation">ALWAYS validate user input using schema validation (e.g., Zod). Validate at system boundaries.</directive>
</directives>

<checklist>
  <check>Code is readable and well-named</check>
  <check>Functions are small (less than 50 lines)</check>
  <check>Files are focused (less than 800 lines)</check>
  <check>No deep nesting (greater than 4 levels)</check>
  <check>Proper error handling</check>
  <check>No console.log statements</check>
  <check>No hardcoded values</check>
  <check>No mutation (immutable patterns used)</check>
</checklist>
