<meta>
  <name>autoresearch</name>
  <type>skill</type>
  <description>Auto-improve any agent prompt using Karpathy's autoresearch method with iterative test-measure-improve loops</description>
  <author>Jennings Liu</author>
  <version>1.0.0</version>
  <license>MIT</license>
</meta>

<purpose>Based on Andrej Karpathy's autoresearch method. Instead of manually improving agent prompts, run an iterative loop: try a small change, score the result, keep improvements, revert regressions. Systematically increase agent output quality.</purpose>

<triggers>Triggers on: "autoresearch", "auto-improve", "optimize agent", "tune prompt", "improve skill quality"</triggers>

<workflow>
  <step n="1">Run agent on test input.</step>
  <step n="2">Score output against checklist (yes/no).</step>
  <step n="3">Record baseline score (average of 3 runs).</step>
  <step n="4">Analyze weakest checklist items.</step>
  <step n="5">Make ONE small change to agent prompt.</step>
  <step n="6">Re-run agent on same test input (3 runs).</step>
  <step n="7">Score again.</step>
  <step n="8">If improved → KEEP change. If dropped → REVERT.</step>
  <step n="9">Repeat until 95%+ score 3 times in a row OR max rounds reached (default: 10).</step>
</workflow>

<process>
  <step n="1" name="Select Agent">User specifies agent. Read from `agents/<name>.md`.</step>
  <step n="2" name="Define Scoring Checklist">3-6 yes/no questions. Each checks one specific aspect. Good: "Does the code review identify at least one production-risk bug?" Bad: "Rate the quality 1-10" (subjective).</step>
  <step n="3" name="Establish Baseline">Run agent on test input 3 times. Score each. Average = baseline.</step>
  <step n="4" name="Improvement Loop">For each round: analyze failing items → hypothesize one change → apply (save backup) → test 3 runs → score → KEEP if improved, REVERT if same/worse → log round.</step>
  <step n="5" name="Output Results">Produce summary (baseline/final score, rounds, changes kept/reverted) and changelog per round (score change, what changed, why, effect).</step>
</process>

<constraints>
  <constraint>**Good changes (one at a time)**: Add specific gotcha, add worked example, add banned-patterns list, add rule targeting weakest item, restructure output template</constraint>
  <constraint>**Bad changes (avoid)**: Rewriting entire prompt, adding vague instructions, adding 5 rules at once, removing sections without testing</constraint>
</constraints>

<gotchas>
  <gotcha>**Overfitting**: Using only one test input optimizes for that case. Use 2-3 diverse inputs.</gotcha>
  <gotcha>**Checklist gaming**: More than 6 items may cause gaming individual checks at expense of quality.</gotcha>
  <gotcha>**Local optima**: Short-term score drops may enable bigger gains. Try "creative rounds" for structural changes.</gotcha>
</gotchas>

<topic name="Data Storage">
  Results stored in `${CLAUDE_PLUGIN_DATA}/autoresearch/`: `[agent-name]-results.json` and `[agent-name]-changelog.md`.
</topic>
