<meta>
  <name>backend-patterns</name>
  <type>template</type>
  <description>Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js 22 LTS, Hono, Drizzle ORM, and Next.js API routes</description>
</meta>

<purpose>Backend architecture patterns and best practices for scalable server-side applications covering API design, repository/service layers, database patterns, caching, error handling, authentication, rate limiting, background jobs, and logging.</purpose>

<topic name="API Design Patterns">
  <constraints>
    <constraint>**RESTful structure**: Resource-based URLs (`/api/markets/:id`). Standard HTTP verbs (GET list, GET single, POST create, PUT replace, PATCH update, DELETE remove). Query parameters for filtering, sorting, and pagination.</constraint>
    <constraint>**Repository pattern**: Abstract data access behind interfaces (findAll, findById, create, update, delete). Implementations use specific data stores (Supabase, Drizzle). Enables testability via mocking and swappable data sources.</constraint>
    <constraint>**Service layer**: Separate business logic from data access. Services compose repositories with business rules (e.g., MarketService uses MarketRepository + vector search + sorting).</constraint>
    <constraint>**Middleware pattern**: Request/response processing pipeline for cross-cutting concerns (auth, logging, rate limiting). Wrap handlers with middleware functions that validate then delegate.</constraint>
  </constraints>
</topic>

<topic name="Database Patterns">
  <constraints>
    <constraint>**Query optimization**: Select only needed columns (`select('id, name, status')`). Never use `select('*')`. Apply filters, ordering, and limits at the query level.</constraint>
    <constraint>**N+1 prevention**: Batch-fetch related entities in a single query using ID collections. Map results to a lookup for O(1) association. Never loop queries for related data.</constraint>
    <constraint>**Transactions**: Use database-level transactions (stored procedures or RPC calls) for multi-table operations. Let the database handle rollback on exception.</constraint>
  </constraints>
</topic>

<topic name="Caching Strategies">
  <constraints>
    <constraint>**Redis caching layer**: Implement a CachedRepository that checks Redis first, falls back to the base repository on miss, and caches results with TTL (e.g., 300s). Provide explicit cache invalidation methods.</constraint>
    <constraint>**Cache-aside pattern**: Check cache → if miss, fetch from DB, write to cache with TTL, return → if hit, return cached data.</constraint>
  </constraints>
</topic>

<topic name="Error Handling">
  <constraints>
    <constraint>**Centralized error handler**: Define custom `ApiError` class with statusCode, message, and isOperational flag. Handle known errors (ApiError, ZodError) with appropriate status codes. Log and mask unexpected errors with 500 status.</constraint>
    <constraint>**Retry with exponential backoff**: Retry failed operations with increasing delays (`2^attempt * 1000ms`). Cap at max retries (default 3). Throw last error after all retries exhausted.</constraint>
  </constraints>
</topic>

<topic name="Authentication and Authorization">
  <constraints>
    <constraint>**JWT validation**: Extract Bearer token from Authorization header. Verify with secret. Return typed payload (userId, email, role). Throw 401 on missing or invalid token.</constraint>
    <constraint>**Role-based access control**: Define permission sets per role (admin: all, moderator: read/write/delete, user: read/write). Create `requirePermission` middleware that checks user role against required permission. Return 403 on insufficient permissions.</constraint>
  </constraints>
</topic>

<topic name="Rate Limiting">
  <constraints>
    <constraint>**In-memory rate limiter**: Track request timestamps per identifier (IP). Sliding window approach: remove expired entries, count recent requests, reject if over threshold (e.g., 100 req/min). Return 429 on exceeded.</constraint>
  </constraints>
</topic>

<topic name="Background Jobs">
  <constraints>
    <constraint>**Simple queue pattern**: In-memory queue with sequential processing. Add jobs without blocking request. Process queue items with error isolation (one failure doesn't stop the queue). Use for non-critical async work like indexing.</constraint>
  </constraints>
</topic>

<topic name="Logging and Monitoring">
  <constraints>
    <constraint>**Structured logging**: JSON-formatted log entries with timestamp, level, message, and context (userId, requestId, method, path). Separate methods for info, warn, error. Include error message and stack trace in error logs.</constraint>
  </constraints>
</topic>

<references>
  <ref>Covers Node.js 22 LTS, Hono, Drizzle ORM, Next.js API routes, Supabase, Redis, Zod validation</ref>
</references>
