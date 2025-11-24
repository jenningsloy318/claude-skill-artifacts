# Research Report: Requirements Elicitation Methodologies

**Date:** 2025-11-24
**Feature:** Enhanced Requirements Clarifier Agent
**Technologies:** Claude Code Plugin, Agent Architecture

---

## 1. Executive Summary

This report documents research findings on requirements elicitation methodologies that can enhance our `requirements-clarifier` agent. The goal is to move beyond simple feature requests to understand the deeper "why" behind user needs, anticipate downstream requirements, and deliver more complete solutions.

**Key Insight from User Example:**
> "Users want to add a download button on the page, simply we can add it. But we can think further, why do users ask for it? If downloaded file or data will be further processed? Can we add this process?"

This represents a shift from **reactive** (just do what's asked) to **proactive** (understand intent and anticipate needs) requirements gathering.

---

## 2. Methodology Landscape

### 2.1 SAP Design Thinking

**Source:** SAP AppHaus, SAP Learning

SAP's Human-Centered Approach to Innovation follows four phases:

| Phase | Purpose | Key Activities |
|-------|---------|----------------|
| **Explore** | Determine which problem needs solving | Align with corporate strategy, identify key initiatives |
| **Discover** | Dig deep with end users | Understand current processes, identify pain points |
| **Design** | Create solutions iteratively | Generate ideas, get user feedback, iterate |
| **Deliver** | Build scalable solutions | Implement, test, deploy |

**Core Principles:**
1. **Empathize First**: Start with understanding the user's context, not the solution
2. **Challenge Assumptions**: "No oven, no hot pizza" → Design thinkers find creative solutions
3. **Iterative Validation**: Prototype and test before full implementation
4. **Cross-functional Collaboration**: Break silo boundaries

**Key Technique - Empathy Mapping:**
- What does the user **Say**?
- What does the user **Think**?
- What does the user **Do**?
- What does the user **Feel**?

---

### 2.2 The 5 Whys Technique

**Source:** Toyota Production System (Sakichi Toyoda, Taiichi Ohno)

A root cause analysis technique that asks "Why?" iteratively (typically 5 times) to get beyond symptoms to root causes.

**Example Application to Requirements:**

```
User: "I need a download button"
Why? → "I need to get the data out of the system"
Why? → "I need to process it in Excel"
Why? → "I need to create a monthly report"
Why? → "Management needs visibility into trends"
Why? → "To make data-driven decisions about inventory"

Root Need: Business intelligence/reporting capability
Better Solution: Built-in analytics dashboard with export
```

**Benefits for Requirements:**
- Uncovers the real problem, not just the stated request
- Identifies opportunities for better solutions
- Prevents building features that don't solve actual needs

---

### 2.3 Jobs to Be Done (JTBD)

**Source:** Clayton Christensen (Harvard), Tony Ulwick, Bob Moesta

**Core Concept:** Customers don't buy products; they "hire" products to do a job.

> "When we buy a product, we essentially 'hire' something to get a job done. If it does the job well, when we are confronted with the same job, we hire that same product again."
> — Clayton Christensen

**Framework Structure:**

```
When [situation/context]
I want to [motivation/goal]
So I can [expected outcome]
```

**Job Categories:**
| Type | Description | Example |
|------|-------------|---------|
| **Functional** | Practical task to complete | "Download data for analysis" |
| **Emotional** | How user wants to feel | "Feel confident in my decisions" |
| **Social** | How user wants to be perceived | "Be seen as data-driven by management" |

**Application to Download Button Example:**

```
Functional Job: Export data from system
Emotional Job: Feel in control of my data
Social Job: Be able to share insights with team

→ Solution might include: Export + Share + Collaboration features
```

**Key Questions:**
1. What job is the user trying to get done?
2. What are the circumstances (context)?
3. What outcome does success look like?
4. What are they currently using to do this job?
5. What frustrations do they have with current solutions?

---

### 2.4 User Story Mapping

**Source:** Jeff Patton

A technique for visualizing the customer journey and organizing requirements around user activities.

**Structure:**
```
Activities (high-level goals)
    ↓
Tasks (steps to achieve activities)
    ↓
Stories (specific features)
```

**Key Principles:**
1. **Tell the whole story**: Map the entire user journey before diving into details
2. **Walk the skeleton**: Identify the minimum viable path first
3. **Slice for releases**: Prioritize by delivering complete thin slices

**Application Example:**

```
Activity: Generate Monthly Report
├── Task: Gather Data
│   ├── Story: Download CSV
│   ├── Story: Select date range
│   └── Story: Filter by category
├── Task: Analyze Data
│   ├── Story: View in spreadsheet
│   └── Story: Create charts
└── Task: Share Report
    ├── Story: Export as PDF
    └── Story: Email to stakeholders
```

**Insight:** The download button is just one story in a larger workflow. Understanding the full map reveals additional opportunities.

---

### 2.5 Impact Mapping

**Source:** Gojko Adzic

A strategic planning technique that connects deliverables to business goals.

**Structure (4 Questions):**
```
WHY? → Business Goal
WHO? → Actors (who can help/hinder)
HOW? → Impacts (behavior changes needed)
WHAT? → Deliverables (features)
```

**Example:**

```
WHY: Reduce time spent on monthly reporting by 50%

WHO:
├── Financial Analysts (primary users)
├── Department Managers (data consumers)
└── IT Support (current workaround providers)

HOW:
├── Analysts can self-serve data exports
├── Managers can view real-time dashboards
└── IT can focus on strategic work, not data requests

WHAT:
├── Self-service export feature
├── Scheduled report generation
├── Real-time analytics dashboard
└── Role-based access control
```

**Key Benefit:** Forces explicit connection between features and business outcomes.

---

### 2.6 Opportunity Solution Tree (OST)

**Source:** Teresa Torres (Continuous Discovery Habits)

A visual framework for product discovery that maps outcomes to opportunities to solutions.

**Structure:**
```
Desired Outcome (business/product goal)
    ↓
Opportunities (customer needs, pain points)
    ↓
Solutions (ideas to address opportunities)
    ↓
Experiments (tests to validate solutions)
```

**Key Principles:**
1. **Start with outcomes**, not solutions
2. **Map multiple opportunities** before choosing one
3. **Generate multiple solutions** for each opportunity
4. **Test assumptions** before building

**Application:**

```
Outcome: Users can efficiently create monthly reports

Opportunities:
├── Data export is manual and time-consuming
├── Users don't know which data to include
├── Report format varies each month
└── Sharing requires multiple steps

Solutions for "Data export is manual":
├── One-click export button
├── Scheduled automatic exports
├── API for programmatic access
└── Direct integration with Excel
```

---

### 2.7 Socratic Questioning

**Source:** Socrates (Greek Philosophy), Critical Thinking Foundation

A method of questioning to stimulate critical thinking and illuminate ideas.

**Question Types:**

| Type | Purpose | Examples |
|------|---------|----------|
| **Clarification** | Understand the request | "What do you mean by...?" "Could you give an example?" |
| **Assumptions** | Surface hidden beliefs | "What are you assuming here?" "Why would someone think that?" |
| **Evidence** | Probe reasoning | "How do you know this?" "What evidence supports this?" |
| **Perspectives** | Consider alternatives | "What would someone who disagrees say?" "Are there other views?" |
| **Implications** | Explore consequences | "If we do this, what else happens?" "What are the consequences?" |
| **Meta-questions** | Reflect on the question | "Why is this question important?" "What was the point of asking that?" |

**Application to Requirements:**
- Don't accept surface requests at face value
- Probe for underlying needs and constraints
- Explore implications of proposed solutions
- Consider alternative perspectives (other users, stakeholders)

---

### 2.8 Event Storming

**Source:** Alberto Brandolini

A collaborative workshop format for exploring complex business domains through events.

**Elements:**
| Color | Element | Description |
|-------|---------|-------------|
| Orange | Domain Events | Things that happen ("Order Placed") |
| Blue | Commands | Actions that trigger events ("Place Order") |
| Yellow | Actors | Who triggers commands (User, System) |
| Pink | External Systems | Systems involved |
| Purple | Policies | Business rules ("If order > $100, apply discount") |
| Red | Hot Spots | Problems, questions, conflicts |

**Key Insight:** By modeling the flow of events, we discover:
- Missing steps in the workflow
- Integration points with other systems
- Edge cases and error scenarios
- Opportunities for automation

---

## 3. Synthesis: Integrated Questioning Framework

Based on the research, I propose a **multi-layer questioning framework** for the requirements-clarifier agent:

### Layer 1: Surface Request (What)
- What exactly is being requested?
- What is the current behavior?
- What would success look like?

### Layer 2: Root Cause (Why - 5 Whys)
- Why do you need this?
- Why is the current solution insufficient?
- Why now? What triggered this request?
- Why this approach vs. alternatives?
- Why does this matter to the business?

### Layer 3: Job to Be Done (Context)
- What job are you trying to accomplish?
- When do you typically need to do this?
- What do you use currently?
- What frustrates you about the current approach?
- What would "done well" look like?

### Layer 4: Workflow Context (User Story Map)
- What happens before this action?
- What happens after?
- Who else is involved?
- What data flows in and out?
- What are the edge cases?

### Layer 5: Impact & Outcome (Impact Map)
- What business outcome does this support?
- Who benefits from this change?
- How will behavior change?
- How will we measure success?

### Layer 6: Opportunities & Alternatives (OST)
- What other ways could we address this need?
- What assumptions are we making?
- What would we need to test?
- What's the minimum viable solution?

---

## 4. Comparison Matrix

| Methodology | Best For | Key Question | Output |
|-------------|----------|--------------|--------|
| Design Thinking | New features, innovation | "What does the user really need?" | Empathy-driven solutions |
| 5 Whys | Bug fixes, problems | "What's the root cause?" | Root cause identification |
| JTBD | Product features | "What job is being hired for?" | Job statements |
| User Story Mapping | Workflow features | "What's the full journey?" | Story map |
| Impact Mapping | Strategic features | "What business outcome?" | Impact map |
| OST | Discovery/validation | "What opportunities exist?" | Opportunity tree |
| Socratic Method | Clarification | "What are we assuming?" | Clear requirements |
| Event Storming | Complex domains | "What events occur?" | Domain model |

---

## 5. Recommendations for Agent Enhancement

### 5.1 Core Enhancements

1. **Add "Why Chain" questioning** - Implement 5 Whys technique to dig deeper
2. **Add "Job Statement" capture** - Ask JTBD-style questions for context
3. **Add "Workflow Exploration"** - Map before and after the requested feature
4. **Add "Impact Assessment"** - Connect to business outcomes
5. **Add "Alternative Generation"** - Propose multiple solutions

### 5.2 Question Templates by Request Type

**For Feature Requests:**
```
1. What job are you trying to get done?
2. What triggers this need? (When/Where)
3. What do you do before/after this action?
4. What would "done perfectly" look like?
5. How would this impact your workflow?
```

**For Bug Fixes:**
```
1. What were you trying to accomplish?
2. What happened vs. what you expected?
3. Why is this blocking you? (Impact)
4. What workaround are you using?
5. When did this start happening?
```

**For Improvements:**
```
1. What's frustrating about the current approach?
2. How often do you encounter this?
3. What have you tried?
4. What would save you the most time?
5. Who else experiences this?
```

### 5.3 Proactive Anticipation Prompts

After gathering requirements, the agent should proactively ask:

1. **Downstream Effects:** "If we add this, will you need to do something with the result?"
2. **Integration Needs:** "Does this need to connect to any other systems or processes?"
3. **Sharing/Collaboration:** "Will others need access to this?"
4. **Automation Opportunity:** "Is this something you do repeatedly?"
5. **Analytics/Reporting:** "Will you need to track or measure this?"

---

## 6. Sources

1. SAP AppHaus Design Thinking - https://apphaus.sap.com/approach
2. SAP Learning Design Thinking - https://learning.sap.com/courses/design-thinking
3. 5 Whys - Toyota Production System, Toolshero
4. Jobs to Be Done - Clayton Christensen, HBS; Tony Ulwick
5. User Story Mapping - Jeff Patton, jpattonassociates.com
6. Impact Mapping - Gojko Adzic, impactmapping.org
7. Opportunity Solution Tree - Teresa Torres, Continuous Discovery Habits
8. Socratic Method - Critical Thinking Foundation
9. Event Storming - Alberto Brandolini, eventstorming.com
10. Requirements Elicitation Techniques - SoftKraft, GeeksforGeeks

---

## 7. Next Steps

1. Update `requirements-clarifier` agent with multi-layer questioning
2. Add proactive anticipation prompts
3. Include methodology selection based on request type
4. Add example outputs for each methodology
5. Test with real-world scenarios
