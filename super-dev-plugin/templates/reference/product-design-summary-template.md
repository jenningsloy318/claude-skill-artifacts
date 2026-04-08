---
name: product-design-summary-template
description: XML-tagged template for the product design summary document. Created by the product-designer agent to cross-reference architecture and UI/UX design decisions when both domains contribute to a feature.
doc-type: product-design-summary
gate-profile: null
---

<document type="product-design-summary">

<metadata>
  <field name="title">Product Design Summary: [Feature Name]</field>
  <field name="date">[timestamp]</field>
  <field name="author">Claude</field>
  <field name="status">Draft</field>
</metadata>

<section title="Scope Classification">
  <field name="scope">FULL_STACK / ARCHITECTURE_ONLY / UI_ONLY</field>
  <paragraph>
    This feature requires [FULL_STACK coordination between architecture and UI/UX design /
    ARCHITECTURE_ONLY design decisions / UI_ONLY design decisions].
  </paragraph>
  <list type="unordered" label="Architecture Components">
    <item>[component 1]</item>
    <item>[component 2]</item>
  </list>
  <list type="unordered" label="UI Components">
    <item>[component 1]</item>
    <item>[component 2]</item>
  </list>
  <list type="unordered" label="Cross-Domain Dependencies">
    <item>[dependency 1]</item>
    <item>[dependency 2]</item>
  </list>
</section>

<section title="Combined Options">

  <option name="Combined Option 1: [Name]">
    <subsection title="Architecture Approach">
      <field name="option-name">[Option Name from architecture-agent]</field>
      <paragraph>[2-3 sentence summary of technical approach]</paragraph>
      <list type="unordered" label="Strengths">
        <item>[Strength 1]</item>
        <item>[Strength 2]</item>
      </list>
      <list type="unordered" label="Weaknesses">
        <item>[Weakness 1]</item>
      </list>
    </subsection>

    <subsection title="UI/UX Approach">
      <field name="option-name">[Option Name from ui-ux-designer]</field>
      <paragraph>[2-3 sentence summary of user experience approach]</paragraph>
      <list type="unordered" label="Strengths">
        <item>[Strength 1]</item>
        <item>[Strength 2]</item>
      </list>
      <list type="unordered" label="Weaknesses">
        <item>[Weakness 1]</item>
      </list>
    </subsection>

    <subsection title="Why These Work Together">
      <list type="unordered">
        <item>[Synergy 1: e.g., "REST API simplicity matches straightforward form UI"]</item>
        <item>[Synergy 2: e.g., "Server-side rendering enables SEO + fast initial load"]</item>
      </list>
    </subsection>

    <field name="technical-complexity">Low/Medium/High</field>
    <field name="ux-quality">Low/Medium/High</field>
    <field name="implementation-effort">Low/Medium/High</field>
  </option>

  <option name="Combined Option 2: [Name]">
    <paragraph>[Same structure as Option 1]</paragraph>
  </option>

  <option name="Combined Option 3: [Name]">
    <paragraph>[Same structure as Option 1]</paragraph>
  </option>

</section>

<section title="Compatibility Matrix">
  <paragraph>Shows which architecture option works with which UI option:</paragraph>
  <table>
    <row header="true">
      <cell>UI Option</cell>
      <cell>Arch Option 1</cell>
      <cell>Arch Option 2</cell>
      <cell>Arch Option 3</cell>
    </row>
    <row>
      <cell>UI Option 1</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
    </row>
    <row>
      <cell>UI Option 2</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
    </row>
    <row>
      <cell>UI Option 3</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
      <cell>[Full / Partial / No]</cell>
    </row>
  </table>
</section>

<section title="Comparison Matrix">
  <table>
    <row header="true">
      <cell>Criteria</cell>
      <cell>Option 1</cell>
      <cell>Option 2</cell>
      <cell>Option 3</cell>
    </row>
    <row header="true">
      <cell>**Architecture**</cell>
      <cell></cell>
      <cell></cell>
      <cell></cell>
    </row>
    <row>
      <cell>Modularity</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Scalability</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Performance</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Security</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row header="true">
      <cell>**UI/UX**</cell>
      <cell></cell>
      <cell></cell>
      <cell></cell>
    </row>
    <row>
      <cell>Learnability</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Efficiency</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Accessibility</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Visual Clarity</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row header="true">
      <cell>**Combined**</cell>
      <cell></cell>
      <cell></cell>
      <cell></cell>
    </row>
    <row>
      <cell>Arch-UI Synergy</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Implementation Effort</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Risk</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>Time-to-Value</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
      <cell>[1-5]</cell>
    </row>
    <row>
      <cell>**TOTAL**</cell>
      <cell>[sum]</cell>
      <cell>[sum]</cell>
      <cell>[sum]</cell>
    </row>
  </table>
</section>

<section title="Selected Option">
  <field name="selected">Combined Option [X]</field>

  <subsection title="Architecture Decision">
    <field name="approach">[Name]</field>
    <list type="unordered" label="Key Patterns">
      <item>[pattern 1]</item>
      <item>[pattern 2]</item>
    </list>
    <reference type="artifact">See `*-architecture.md`</reference>
  </subsection>

  <subsection title="UI/UX Decision">
    <field name="approach">[Name]</field>
    <list type="unordered" label="Key Patterns">
      <item>[pattern 1]</item>
      <item>[pattern 2]</item>
    </list>
    <reference type="artifact">See `*-design-spec.md`</reference>
  </subsection>

  <subsection title="Rationale">
    <paragraph>[2-3 sentences explaining why this combination was selected]</paragraph>
  </subsection>

  <subsection title="Trade-offs">
    <list type="unordered">
      <item>**What we gain:** [architecture + UX benefits]</item>
      <item>**What we give up:** [architecture + UX costs]</item>
    </list>
  </subsection>
</section>

<section title="Cross-Domain Contracts">

  <subsection title="API to UI Data Flow">
    <table>
      <row header="true">
        <cell>API Endpoint</cell>
        <cell>UI Component</cell>
        <cell>Data Shape</cell>
      </row>
      <row>
        <cell>[endpoint]</cell>
        <cell>[component]</cell>
        <cell>[shape]</cell>
      </row>
    </table>
  </subsection>

  <subsection title="UI to API Interactions">
    <table>
      <row header="true">
        <cell>User Action</cell>
        <cell>API Call</cell>
        <cell>Expected Response</cell>
      </row>
      <row>
        <cell>[action]</cell>
        <cell>[call]</cell>
        <cell>[response]</cell>
      </row>
    </table>
  </subsection>

  <subsection title="Shared State">
    <list type="unordered">
      <item>[Shared state element 1: description and ownership]</item>
      <item>[Shared state element 2: description and ownership]</item>
    </list>
  </subsection>

  <subsection title="Event Interfaces">
    <list type="unordered">
      <item>[Event 1: source -> target, payload description]</item>
      <item>[Event 2: source -> target, payload description]</item>
    </list>
  </subsection>

  <subsection title="Constraints Applied">
    <list type="unordered">
      <item>Architecture constraints on UI: [list]</item>
      <item>UI requirements on architecture: [list]</item>
    </list>
  </subsection>

</section>

<section title="Output Artifacts">
  <list type="unordered">
    <item>Architecture document: <reference type="artifact">`*-architecture.md`</reference></item>
    <item>Design specification: <reference type="artifact">`*-design-spec.md`</reference></item>
    <item>Product design summary: <reference type="artifact">`*-product-design-summary.md` (this document)</reference></item>
    <item>ADR files: <reference type="artifact">`*-adr-[topic].md` (as needed)</reference></item>
  </list>
</section>

<section title="Quality Gates">
  <checklist>
    <item>Scope correctly classified (FULL_STACK vs single domain)</item>
    <item>Both architecture and UI agents invoked (for FULL_STACK)</item>
    <item>Combined options presented with compatibility matrix</item>
    <item>User selection obtained before finalizing</item>
    <item>All output documents generated</item>
    <item>Cross-domain contracts documented (API, state, events)</item>
    <item>No conflicting decisions between architecture and UI</item>
    <item>Every UI interaction has a supporting API endpoint</item>
    <item>Every API response shape matches UI data requirements</item>
    <item>Performance constraints are compatible (API latency vs UI responsiveness)</item>
    <item>Security model supports required user flows</item>
  </checklist>
</section>

</document>
