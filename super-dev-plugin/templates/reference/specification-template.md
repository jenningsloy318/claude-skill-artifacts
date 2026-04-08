---
name: specification-template
description: XML-tagged template for comprehensive technical specifications. Agents load this template and fill in placeholders to produce consistently formatted specification documents with full traceability.
doc-type: specification
gate-profile: gate-spec-trace
---

<document type="specification">

<metadata>
  <field name="title">Technical Specification: [Feature/Fix Name]</field>
  <field name="date">[timestamp]</field>
  <field name="author">Claude</field>
  <field name="status">Draft</field>
</metadata>

<section title="1. Overview">

  <subsection title="1.1 Summary">
    <paragraph>[Brief description of what will be built/fixed]</paragraph>
  </subsection>

  <subsection title="1.2 Goals">
    <list type="unordered">
      <item>[Goal 1]</item>
      <item>[Goal 2]</item>
    </list>
  </subsection>

  <subsection title="1.3 Non-Goals">
    <list type="unordered">
      <item>[What is explicitly out of scope]</item>
    </list>
  </subsection>

</section>

<section title="2. Background">

  <subsection title="2.1 Context">
    <paragraph>[Reference research report findings]</paragraph>
    <quote source="Research Report">[key finding]</quote>
  </subsection>

  <subsection title="2.2 Current State">
    <paragraph>[Reference assessment findings]</paragraph>
    <quote source="Assessment">[key finding]</quote>
  </subsection>

  <subsection title="2.3 Problem Statement">
    <paragraph>[Reference debug analysis if applicable]</paragraph>
    <quote source="Debug Analysis">[root cause]</quote>
  </subsection>

</section>

<section title="3. Technical Design">

  <subsection title="3.1 Architecture">
    <diagram type="ascii">
┌─────────────────┐     ┌─────────────────┐
│   Component A   │────▶│   Component B   │
│                 │     │                 │
│ - Responsibility│     │ - Responsibility│
└─────────────────┘     └─────────────────┘
        │                       │
        ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│   Component C   │     │   Component D   │
└─────────────────┘     └─────────────────┘
    </diagram>
  </subsection>

  <subsection title="3.2 Components">

    <subsection title="Component 1: [Name]">
      <field name="purpose">[description]</field>
      <list type="unordered" label="Responsibilities">
        <item>[responsibility 1]</item>
        <item>[responsibility 2]</item>
      </list>
      <field name="interface">
        <code lang="typescript">
interface [SpecificComponentName] {
  [descriptiveMethod](): ReturnType;
  [anotherDescriptiveMethod](): AnotherType;
}
        </code>
      </field>
      <field name="file-location">`path/to/[specific-filename].ts`</field>
      <field name="naming-convention">
        - Class: `[FeatureName][ComponentType]` (e.g., `UserAuthenticationService`)
        - Methods: `[verb][Noun]` (e.g., `validateUserCredentials()`, `fetchUserProfile()`)
        - Variables: `[feature][entity][property]` (e.g., `userAuthenticationState`)
      </field>
    </subsection>

    <subsection title="Component 2: [Name]">
      <paragraph>[same structure with specific names]</paragraph>
    </subsection>

  </subsection>

  <subsection title="3.3 Data Model (MANDATORY: Specific Field Names)">
    <code lang="typescript">
/**
 * [FeatureName][EntityName] - [Brief description]
 */
interface [FeatureName][EntityName] {
  // Primary identification
  [entity]Id: string;              // e.g., userId, orderId
  [entity]Name: string;            // e.g., userName, productName

  // Core attributes
  [entity][Property]: Type;        // e.g., userEmail, productPrice
  [entity][Attribute]: Type;       // e.g., userStatus, orderStatus

  // Metadata
  [entity]CreatedAt: Date;         // Always use descriptive suffix
  [entity]UpdatedAt: Date;         // Always use descriptive suffix
}
    </code>

    <rule title="Naming Rules (MANDATORY)">
      <list type="unordered">
        <item>**NO generic names** like `data`, `item`, `value`, `result`, `temp`</item>
        <item>**NO single letters** except loop indices (i, j, k)</item>
        <item>**NO abbreviations** except well-known ones (id, url, api)</item>
        <item>**USE feature-specific prefixes** (e.g., `userAuth...`, `orderProcess...`)</item>
        <item>**USE descriptive suffixes** (e.g., `...State`, `...Config`, `...Count`, `...List`)</item>
      </list>
    </rule>

    <paragraph>[Database changes if applicable]</paragraph>
  </subsection>

  <subsection title="3.4 API Design">

    <subsection title="Endpoint 1: [Method] [Path]">
      <field name="function-name">`[feature][Action]` (e.g., `userLogin`, `orderCreate`)</field>

      <field name="request">
        <code lang="json">
{
  "[entity][Property]": "value",  // e.g., "userEmail": "user@example.com"
  "[entity][Attribute]": "value"  // e.g., "userPassword": "secret123"
}
        </code>
      </field>

      <field name="response">
        <code lang="json">
{
  "[feature][Entity]": {          // e.g., "authenticatedUser": {...}
    "[entity]Id": "string",
    "[entity]Name": "string"
  }
}
        </code>
      </field>

      <field name="errors">
        <list type="unordered">
          <item>`400`: [specific error condition with descriptive name]</item>
          <item>`404`: [specific error condition]</item>
        </list>
      </field>
    </subsection>

  </subsection>

  <subsection title="3.5 Function Specifications (MANDATORY: No Ambiguity)">

    <subsection title="Function: [FeatureName][Action] (e.g., UserAuthenticate)">
      <code lang="typescript">
/**
 * [One-sentence description of what this function does]
 * @param [descriptiveParamName] - [description of what this param represents]
 * @returns [description of what is returned]
 * @throws [SpecificErrorType] - [when this error is thrown]
 */
async function [featureName][action](
  [descriptiveParamName]: ParamType,
  [anotherDescriptiveParam]: AnotherType
): Promise&lt;ReturnType&gt; {
  // Implementation is unambiguous because:
  // 1. All parameter names are feature-specific and descriptive
  // 2. Return type is explicitly defined
  // 3. Error conditions are documented
  // 4. No "data", "result", or "value" generic names
}
      </code>
    </subsection>

    <rule title="Ambiguity Prevention Rules">
      <list type="unordered">
        <item>**Every function has a descriptive name** reflecting its action and feature</item>
        <item>**Every parameter has a descriptive name** indicating what it represents</item>
        <item>**Return types are explicit** - no `any`, no `unknown`</item>
        <item>**Error cases are documented** - all possible errors listed</item>
        <item>**No optional behaviors** - if something is conditional, document the condition</item>
      </list>
    </rule>

  </subsection>

  <subsection title="3.6 Variable Naming Conventions (MANDATORY)">
    <table>
      <row header="true">
        <cell>Variable Type</cell>
        <cell>Naming Pattern</cell>
        <cell>Examples</cell>
        <cell>Prohibited</cell>
      </row>
      <row>
        <cell>Local variables</cell>
        <cell>`[feature][entity][property]`</cell>
        <cell>`userAuthState`, `orderTotal`</cell>
        <cell>`data`, `val`, `temp`</cell>
      </row>
      <row>
        <cell>Parameters</cell>
        <cell>`[descriptive][entity]`</cell>
        <cell>`userData`, `requestConfig`</cell>
        <cell>`obj`, `arg`, `param`</cell>
      </row>
      <row>
        <cell>Constants</cell>
        <cell>`[FEATURE_NAME]_[CONSTANT]`</cell>
        <cell>`MAX_LOGIN_ATTEMPTS`, `DEFAULT_TIMEOUT`</cell>
        <cell>`limit`, `max`</cell>
      </row>
      <row>
        <cell>Booleans</cell>
        <cell>`[is/has/should][Condition]`</cell>
        <cell>`isAuthenticated`, `hasPermission`</cell>
        <cell>`flag`, `status`</cell>
      </row>
      <row>
        <cell>Arrays</cell>
        <cell>`[entity][List/Array]`</cell>
        <cell>`userList`, `orderArray`</cell>
        <cell>`items`, `list`</cell>
      </row>
      <row>
        <cell>Functions</cell>
        <cell>`[verb][Noun]` or `[feature][Action]`</cell>
        <cell>`getUserById()`, `authenticateUser()`</cell>
        <cell>`process()`, `handle()`</cell>
      </row>
    </table>
  </subsection>

  <subsection title="3.7 Error Handling">
    <table>
      <row header="true">
        <cell>Error Case</cell>
        <cell>Handler</cell>
        <cell>User Feedback</cell>
        <cell>Error Variable Name</cell>
      </row>
      <row>
        <cell>[specific case]</cell>
        <cell>[handler]</cell>
        <cell>[message]</cell>
        <cell>`[feature]Error`</cell>
      </row>
      <row>
        <cell>[specific case]</cell>
        <cell>[handler]</cell>
        <cell>[message]</cell>
        <cell>`[entity]NotFound`</cell>
      </row>
    </table>
  </subsection>

</section>

<section title="4. Implementation Approach">

  <subsection title="4.1 Technology Stack">
    <list type="unordered">
      <item>Language: [language]</item>
      <item>Framework: [framework]</item>
      <item>Libraries: [list]</item>
    </list>
  </subsection>

  <subsection title="4.2 Dependencies">
    <table>
      <row header="true">
        <cell>Dependency</cell>
        <cell>Version</cell>
        <cell>Purpose</cell>
      </row>
      <row>
        <cell>[name]</cell>
        <cell>[version]</cell>
        <cell>[why needed]</cell>
      </row>
    </table>
  </subsection>

  <subsection title="4.3 Configuration">
    <code lang="text">
[Configuration changes needed]
    </code>
  </subsection>

</section>

<section title="5. Testing Strategy">

  <subsection title="5.1 Unit Tests">
    <table>
      <row header="true">
        <cell>Component</cell>
        <cell>Test Function Name</cell>
        <cell>Test Cases</cell>
      </row>
      <row>
        <cell>[component]</cell>
        <cell>`[feature][Action][Should/When]`</cell>
        <cell>[cases]</cell>
      </row>
    </table>

    <rule title="Test Naming Convention">
      <paragraph>Format: `[featureName]_[action]_should_[expectedOutcome]`</paragraph>
      <list type="unordered">
        <item>`userLogin_should_returnToken_when_credentialsValid`</item>
        <item>`orderCreate_should_failInsufficientFunds_when_balanceLow`</item>
      </list>
    </rule>
  </subsection>

  <subsection title="5.2 Integration Tests">
    <paragraph>[Integration test approach]</paragraph>
  </subsection>

  <subsection title="5.3 Edge Cases">
    <table>
      <row header="true">
        <cell>Edge Case</cell>
        <cell>Expected Behavior</cell>
        <cell>Test Function Name</cell>
      </row>
      <row>
        <cell>[case]</cell>
        <cell>[behavior]</cell>
        <cell>`[feature][Action][EdgeCase]`</cell>
      </row>
    </table>
  </subsection>

  <subsection title="5.4 BDD Scenario References">
    <paragraph>Tests MUST reference BDD scenario IDs from `*-behavior-scenarios.md`:</paragraph>

    <table>
      <row header="true">
        <cell>Scenario ID</cell>
        <cell>Title</cell>
        <cell>Test Type</cell>
        <cell>Test Location</cell>
      </row>
      <row>
        <cell>SCENARIO-001</cell>
        <cell>[title]</cell>
        <cell>Unit/Integration/E2E</cell>
        <cell>[planned test file]</cell>
      </row>
    </table>

    <rule title="BDD Test Naming Convention">
      <paragraph>Test names or comments MUST include the SCENARIO-XXX ID.</paragraph>
      <list type="unordered">
        <item>`describe('SCENARIO-001: Registered user accesses account', ...)`</item>
        <item>`// SCENARIO-001` comment above test function</item>
        <item>`test_scenario_001_registered_user_access()` function name</item>
      </list>
    </rule>
  </subsection>

</section>

<section title="6. Security Considerations">

  <subsection title="6.1 Input Validation">
    <table>
      <row header="true">
        <cell>Input</cell>
        <cell>Validation</cell>
        <cell>Sanitization</cell>
      </row>
      <row>
        <cell>[input field]</cell>
        <cell>[validation rules]</cell>
        <cell>[sanitization method]</cell>
      </row>
    </table>
  </subsection>

  <subsection title="6.2 Authentication and Authorization">
    <list type="unordered">
      <item>**Auth required:** [yes/no]</item>
      <item>**Permission checks:** [list of permissions]</item>
      <item>**Role restrictions:** [roles that can access]</item>
    </list>
  </subsection>

  <subsection title="6.3 Data Protection">
    <list type="unordered">
      <item>**Sensitive data:** [list fields containing PII, credentials, etc.]</item>
      <item>**Encryption:** [at rest / in transit requirements]</item>
      <item>**Logging:** [what to log, what to redact]</item>
    </list>
  </subsection>

  <subsection title="6.4 OWASP Considerations">
    <table>
      <row header="true">
        <cell>Risk</cell>
        <cell>Applicable</cell>
        <cell>Mitigation</cell>
      </row>
      <row>
        <cell>Injection</cell>
        <cell>[yes/no]</cell>
        <cell>[mitigation]</cell>
      </row>
      <row>
        <cell>Broken Auth</cell>
        <cell>[yes/no]</cell>
        <cell>[mitigation]</cell>
      </row>
      <row>
        <cell>XSS</cell>
        <cell>[yes/no]</cell>
        <cell>[mitigation]</cell>
      </row>
      <row>
        <cell>CSRF</cell>
        <cell>[yes/no]</cell>
        <cell>[mitigation]</cell>
      </row>
      <row>
        <cell>Security Misconfiguration</cell>
        <cell>[yes/no]</cell>
        <cell>[mitigation]</cell>
      </row>
    </table>
  </subsection>

</section>

<section title="7. Performance Considerations">

  <subsection title="7.1 Complexity Analysis">
    <table>
      <row header="true">
        <cell>Operation</cell>
        <cell>Function Name</cell>
        <cell>Time Complexity</cell>
        <cell>Space Complexity</cell>
      </row>
      <row>
        <cell>[operation]</cell>
        <cell>`[feature][Action]`</cell>
        <cell>O([complexity])</cell>
        <cell>O([complexity])</cell>
      </row>
    </table>
  </subsection>

  <subsection title="7.2 Database Optimization">
    <list type="unordered">
      <item>**Indexes needed:** [list of indexes with field names]</item>
      <item>**Query optimization:** [N+1 prevention, batch operations]</item>
      <item>**Connection pooling:** [requirements]</item>
    </list>
  </subsection>

  <subsection title="7.3 Caching Strategy">
    <table>
      <row header="true">
        <cell>Data</cell>
        <cell>Cache Key Pattern</cell>
        <cell>Cache Type</cell>
        <cell>TTL</cell>
        <cell>Invalidation</cell>
      </row>
      <row>
        <cell>[data]</cell>
        <cell>`[feature]:[entity]:[id]`</cell>
        <cell>[memory/redis/cdn]</cell>
        <cell>[duration]</cell>
        <cell>[trigger]</cell>
      </row>
    </table>
  </subsection>

  <subsection title="7.4 Scalability">
    <list type="unordered">
      <item>**Bottlenecks:** [identified bottlenecks]</item>
      <item>**Horizontal scaling:** [considerations]</item>
      <item>**Rate limiting:** [requirements]</item>
    </list>
  </subsection>

  <subsection title="7.5 Resource Usage">
    <list type="unordered">
      <item>**Memory:** [expected usage, limits]</item>
      <item>**CPU:** [expected usage, async considerations]</item>
      <item>**Network:** [payload sizes, request frequency]</item>
    </list>
  </subsection>

</section>

<section title="8. Rollout Plan">
  <list type="ordered">
    <item>[Step 1]</item>
    <item>[Step 2]</item>
  </list>

  <subsection title="8.1 Implementation Plan">
    <reference type="cross-document">See `*-implementation-plan.md` for phased implementation milestones.</reference>
    <reference type="cross-document">See `*-task-list.md` for full task breakdown with file paths and acceptance criteria.</reference>
  </subsection>
</section>

<section title="9. Unambiguous Implementation Requirements (MANDATORY)">

  <subsection title="9.1 Single Implementation Guarantee">
    <paragraph>This specification MUST result in exactly ONE valid implementation. To ensure this:</paragraph>
    <checklist>
      <item>**All function names are specified** - No room for interpretation</item>
      <item>**All parameter names are specified** - No "data", "result", or generic names</item>
      <item>**All variable names follow conventions** - Feature-specific prefixes required</item>
      <item>**All file paths are specified** - No ambiguity about where code goes</item>
      <item>**All conditional behaviors are documented** - No "if needed, do X"</item>
      <item>**All error cases are listed** - No "handle errors appropriately"</item>
      <item>**All data structures are fully defined** - No "etc." or "and so on"</item>
    </checklist>
  </subsection>

  <subsection title="9.2 Ambiguity Checklist">
    <paragraph>Review this specification against these ambiguity sources:</paragraph>
    <checklist>
      <item>**No pronouns** - Replace "it", "they", "this" with specific nouns</item>
      <item>**No "etc." or "and so on"** - List everything explicitly</item>
      <item>**No "appropriate" or "suitable"** - Specify exact values</item>
      <item>**No "handle" or "process"** - Specify exact actions</item>
      <item>**No "if needed" or "when applicable"** - Specify exact conditions</item>
      <item>**No generic names** - All names are feature-specific</item>
      <item>**No optional behaviors** - Everything is required or explicitly conditional</item>
    </checklist>
  </subsection>

  <subsection title="9.3 Naming Convention Verification">
    <checklist>
      <item>**No generic variable names** (data, item, value, result, temp, obj)</item>
      <item>**No single-letter names** (except loop indices i, j, k)</item>
      <item>**No abbreviations** (except id, url, api, http, etc.)</item>
      <item>**All names use feature-specific prefixes**</item>
      <item>**All functions use verb-noun pattern**</item>
      <item>**All constants use UPPER_CASE**</item>
      <item>**All booleans use is/has/should prefix**</item>
    </checklist>
  </subsection>

</section>

<section title="10. Open Questions">
  <checklist>
    <item>[Question 1]</item>
    <item>[Question 2]</item>
  </checklist>
</section>

<section title="11. References (MUST include canonical links to source documents)">
  <list type="unordered">
    <item>Requirements (super-dev:requirements-clarifier): [link]</item>
    <item>Research Report (super-dev:research-agent): [link]</item>
    <item>Assessment (super-dev:code-assessor): [link]</item>
    <item>Architecture (super-dev:architecture-agent): [link if applicable]</item>
    <item>Design Spec (super-dev:ui-ux-designer): [link if applicable]</item>
    <item>Debug Analysis (super-dev:debug-analyzer): [link if applicable]</item>
  </list>
</section>

<rule title="Gate Compliance (gate-spec-trace.sh)">
  <paragraph>The output specification file MUST satisfy these automated gate checks or the workflow will be blocked:</paragraph>
  <list type="ordered">
    <item>**BDD scenario references** - MUST contain at least 1 `SCENARIO-[0-9]+` pattern (e.g., `SCENARIO-001`). Cross-reference scenarios in Section 5.4.</item>
    <item>**Testing strategy text** - MUST contain at least one of: "testing strategy", "test plan", "test approach", "test coverage", "unit test", "integration test" (case-insensitive). Section 5 heading satisfies this.</item>
    <item>**Task list file exists** - `*-task-list.md` must exist as a separate file in the spec directory.</item>
    <item>**Implementation plan file exists** - `*-implementation-plan.md` must exist as a separate file in the spec directory.</item>
  </list>
</rule>

</document>
