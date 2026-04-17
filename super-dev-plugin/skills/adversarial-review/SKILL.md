---
name: adversarial-review
description: Multi-lens adversarial review with Skeptic, Architect, and Minimalist lenses and 7+ attack vectors
---

<purpose>Perform multi-lens adversarial review to challenge implementation correctness, structural fitness, and necessity. Apply Skeptic, Architect, and Minimalist lenses with attack vectors (V1-V8) and a Destructive Action Gate. Produce a verdict (PASS/CONTESTED/REJECT).</purpose>

<triggers>Triggers on: "/super-dev:adversarial-review", Phase 9 invocation by Team Lead</triggers>

<workflow>
  <step n="1" name="Scope and Intent">Determine what to review. State intent. Assess change size for reviewer count (Small: 1 Skeptic, Medium: 2 Skeptic+Architect, Large: 3 all lenses).</step>
  <step n="2" name="Skeptic Lens">Challenge correctness — V1 false assumptions, V2 edge cases, V3 failure modes, V4 adversarial input, V5 safety/compliance, V6 grounding audit, V8 behavior coverage.</step>
  <step n="3" name="Architect Lens">Challenge structural fitness — V1 architectural assumptions, V3 graceful degradation, V5 security boundaries, V7 dependencies.</step>
  <step n="4" name="Minimalist Lens">Challenge necessity — V7 dependency justification, unnecessary abstractions, premature configuration.</step>
  <step n="5" name="Destructive Action Gate">Always-on scan for: DAT (data destruction), IRR (irreversible state), PRD (production impact), PRM (permission escalation), SEC (secret operations). No safeguard → HALT finding.</step>
  <step n="6" name="Verdict">HALT findings → CONTESTED minimum (multiple HALTs → REJECT). No high-severity → PASS. High with disagreement → CONTESTED. High with consensus → REJECT.</step>
</workflow>

<constraints>
  <constraint>Verdict only — do NOT make code changes</constraint>
  <constraint>Every finding MUST include file:line references and concrete recommendations</constraint>
  <constraint>Each lens is exclusive — no blending between reviewer perspectives</constraint>
  <constraint>HALT findings cannot be downgraded; require explicit Team Lead acknowledgment</constraint>
</constraints>
