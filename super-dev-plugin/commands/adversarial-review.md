<meta>
  <name>adversarial-review</name>
  <type>command</type>
  <description>Perform multi-lens adversarial review to challenge implementation correctness, structural fitness, and necessity</description>
</meta>

<purpose>Activate the adversarial-reviewer agent for Phase 9 multi-lens review. Challenges implementation from Skeptic (correctness), Architect (structural fitness), and Minimalist (necessity) perspectives. Runs in parallel with code review. Produces verdict (PASS/CONTESTED/REJECT).</purpose>

<usage>/super-dev:adversarial-review [implementation context]</usage>

<topic name="Review Lenses">
  **Skeptic**: Challenges correctness and completeness — what inputs/states break this? What error paths are unhandled? What race conditions exist? **Architect**: Challenges structural fitness — does design serve the goal? Where are coupling points? What boundary violations exist? **Minimalist**: Challenges necessity — what can be deleted? Where is premature abstraction? What config exists without second use case?
</topic>

<topic name="Destructive Action Gate">
  Always-on checkpoint scanning for irreversible operations: data destruction (DROP TABLE, rm -rf), irreversible state (force push, DROP COLUMN), production impact (prod deploy, DNS changes), permission escalation (chmod 777, disable auth), secret operations (delete API keys).
</topic>

<output>
  <format>Adversarial review report with: lens-tagged findings (Skeptic/V1-V8, Architect/V1-V7, Minimalist/V7), destructive action gate results, verdict (PASS/CONTESTED/REJECT).</format>
</output>

<constraints>
  <constraint>Runs in parallel with code review in Phase 9</constraint>
  <constraint>PASS → Phase 10. CONTESTED → Team Lead decides. REJECT → loop back to Phase 8.</constraint>
</constraints>
