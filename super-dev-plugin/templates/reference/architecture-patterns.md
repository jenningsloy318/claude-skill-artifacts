<meta>
  <name>architecture-patterns</name>
  <type>template</type>
  <description>Software architecture patterns, principles, and best practices for system design</description>
</meta>

<purpose>Reference for software architecture design during Stage 6.3 (Architecture Design) of the super-dev workflow. Covers SOLID principles, module decomposition, data access, communication, state management, caching, and deployment patterns.</purpose>

<principles>
  <principle name="YAGNI">Design only architecture explicitly required. No speculative modules or over-engineering. Each decision must serve documented requirements.</principle>
  <principle name="SOLID">Single Responsibility (one reason to change), Open/Closed (extend not modify), Liskov Substitution (subtypes substitutable), Interface Segregation (many specific over one general), Dependency Inversion (depend on abstractions).</principle>
  <principle name="Boring Architecture First">Prefer proven, familiar patterns. Standard 3-tier, MVC, or Clean Architecture unless requirements demand otherwise. Simple over clever.</principle>
  <principle name="No Wheel Reinvention">Prefer reusing mature open-source components over building custom solutions.</principle>
  <principle name="Glue Code">Minimal integration adapters/layers that connect reused components to existing systems.</principle>
  <principle name="Interface-first Modularity">Define contracts (interfaces/ports) before implementations.</principle>
</principles>

<reference name="Decision Framework">
  Evaluate architecture options across weighted criteria:

  Technical Quality (0.50): Modularity (0.10), Coupling/Cohesion (0.10), Scalability (0.10), Performance (0.10), Security (0.10).

  Delivery (0.30): Implementation Complexity (0.08), Risk (0.08), Time-to-Value (0.07), Maintainability (0.04), Testability (0.03).

  Operational (0.20): Observability (0.05), Reliability (0.05), Cost (0.05), Supportability (0.03), Reversibility (0.02).

  Scoring: 5 Excellent, 4 Good, 3 Acceptable, 2 Fair, 1 Poor, 0 Unacceptable.
</reference>

<pattern name="Module Decomposition Patterns">
  Domain-Driven Design (DDD): Bounded Contexts define business capability boundaries. Aggregates group related entities as consistency boundaries. Ubiquitous Language within contexts. Context Mapping defines relationships. Best for complex business domains, large teams, long-lived projects.

  Layered Architecture: Presentation → Business Logic → Data Access → Database/External. Best for traditional CRUD applications, small to medium teams, clear separation of concerns.

  Hexagonal/Clean Architecture: Core entities → Use Cases → Adapters (Web, DB, API). Best for complex business logic, multiple delivery mechanisms, testability-critical systems.

  Microservices: Independent services with separate databases, connected via API Gateway/Message Bus. Best for large teams with independent deployment needs, different scalability per service, technology diversity. Trade-offs: increased operational complexity, distributed transactions.
</pattern>

<pattern name="Data Access Patterns">
  Repository Pattern: Centralized data access logic behind an interface (findById, save, delete). Easy to mock for testing, swappable data sources.

  Data Mapper vs Active Record: Choose Data Mapper when complex business logic in domain models, need to decouple from database schema, or multiple data sources for same entity.

  CQRS: Separate write model (Commands) from read model (Queries). Best for high read/write ratio workloads, complex query requirements, eventual consistency acceptable.
</pattern>

<pattern name="Communication Patterns">
  REST API: Resource-based URLs, HTTP verbs, stateless. Best for standard CRUD, public APIs.

  GraphQL: Schema-driven, single endpoint, typed queries, client-controlled data shape. Best for complex data requirements, mobile clients.

  gRPC: Protocol Buffers, strong typing, bidirectional streaming. Best for microservice communication, high-performance needs.

  Message Queues (RabbitMQ, SQS, Kafka): Asynchronous, event-driven, decoupled producers/consumers. Best for eventual consistency, background processing, fan-out.
</pattern>

<pattern name="State Management Patterns">
  Client-Side: Local component state (useState — simple, isolated), Context/Redux (global shared state — complex, many consumers), Server State via React Query/SWR (caching, synchronization).

  Server-Side: Session store in-memory or Redis (user session data), Database for persistent state (PostgreSQL, MongoDB), Cache layer via Redis/Memcached (frequently accessed data).
</pattern>

<pattern name="Caching Strategies">
  Cache-Aside (Lazy Loading): Check cache → if miss, load from DB, write to cache, return → if hit, return cached.

  Write-Through: Write to cache → write to DB synchronously → return.

  Write-Behind (Write-Back): Write to cache → return immediately → async write to DB.
</pattern>

<pattern name="Error Handling Patterns">
  Circuit Breaker: Track failures, open circuit when threshold exceeded (reject fast), half-open to test recovery. Prevents cascading failures.

  Retry with Exponential Backoff: Retry failed operations with increasing delays (1s, 2s, 4s). Cap at max attempts. Prevents overwhelming failing services.
</pattern>

<pattern name="Deployment Architectures">
  Monolith: Single deployable unit, shared database. Pros: simpler deployment, easier local dev. Cons: scaling limitations, technology lock-in.

  Microservices: Independent services, separate databases. Pros: independent scaling, technology diversity. Cons: operational complexity, distributed transactions.

  Serverless (FaaS): Event-driven, function-as-a-service. Pros: zero scaling management, pay-per-use. Cons: cold starts, vendor lock-in.
</pattern>

<reference name="Architecture Decision Records">
  Use MADR 3.0.0 format: Status (Proposed/Accepted/Deprecated), Context (motivating issue), Decision (proposed change), Consequences (positive, negative, risks, mitigation).
</reference>

<reference name="Common Trade-offs">
  SQL vs NoSQL: ACID needed → SQL; Schema flexibility → NoSQL.
  Monolith vs Microservices: Small team → Monolith; Independent scaling → Microservices.
  Sync vs Async: Immediate response → Sync; Background work → Async.
  Stateful vs Stateless: Simple → Stateless; Session required → Stateful.
</reference>

<references>
  <ref>Extracted from `super-dev:architecture-agent`. For full agent behavior during Stage 6.3, invoke with subagent_type "super-dev:architecture-agent".</ref>
</references>
