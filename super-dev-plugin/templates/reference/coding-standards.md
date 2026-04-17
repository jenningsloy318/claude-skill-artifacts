<meta>
  <name>coding-standards</name>
  <type>template</type>
  <description>Universal coding standards, best practices, and patterns for TypeScript, JavaScript, React, and Node.js development</description>
</meta>

<purpose>Universal coding standards applicable across all projects covering code quality principles, TypeScript/JavaScript standards, React best practices, API design, file organization, and testing patterns.</purpose>

<principles>
  <principle>**Readability First**: Code is read more than written. Use clear variable and function names, self-documenting code preferred over comments, consistent formatting.</principle>
  <principle>**KISS (Keep It Simple)**: Simplest solution that works. Avoid over-engineering. No premature optimization. Easy to understand over clever code.</principle>
  <principle>**DRY (Don't Repeat Yourself)**: Extract common logic into functions, create reusable components, share utilities across modules, avoid copy-paste programming.</principle>
  <principle>**YAGNI (You Aren't Gonna Need It)**: Don't build features before they're needed. Avoid speculative generality. Add complexity only when required.</principle>
</principles>

<topic name="TypeScript/JavaScript Standards">
  <constraints>
    <constraint>**Variable naming**: Use descriptive names (`marketSearchQuery`, `isUserAuthenticated`, `totalRevenue`), not abbreviations (`q`, `flag`, `x`)</constraint>
    <constraint>**Function naming**: Use verb-noun pattern (`fetchMarketData`, `calculateSimilarity`, `isValidEmail`), not noun-only names</constraint>
    <constraint>**Immutability**: ALWAYS use spread operator for updates (`{...user, name: 'New'}`, `[...items, newItem]`). NEVER mutate directly (`user.name = x`, `items.push(x)`)</constraint>
    <constraint>**Error handling**: Always use try/catch with meaningful error messages. Check response.ok before parsing. Re-throw with context.</constraint>
    <constraint>**Async/Await**: Use `Promise.all()` for parallel execution when operations are independent. Avoid sequential awaits when unnecessary.</constraint>
    <constraint>**Type safety**: Define proper interfaces. Use union types for enums (`'active' | 'resolved'`). Never use `any` type.</constraint>
  </constraints>
</topic>

<topic name="React Best Practices">
  <constraints>
    <constraint>**Components**: Use functional components with typed props interfaces. Destructure props with defaults. Use composition over inheritance.</constraint>
    <constraint>**Custom hooks**: Extract reusable logic into hooks (e.g., `useDebounce`, `useToggle`). Name with `use` prefix.</constraint>
    <constraint>**State management**: Use functional updates for state based on previous state (`setCount(prev => prev + 1)`). Avoid stale closure references.</constraint>
    <constraint>**Conditional rendering**: Use logical AND for simple conditionals. Avoid deeply nested ternaries.</constraint>
  </constraints>
</topic>

<topic name="API Design Standards">
  <constraints>
    <constraint>**REST conventions**: Resource-based URLs (`/api/markets/:id`). Standard HTTP verbs (GET, POST, PUT, PATCH, DELETE). Query params for filtering/pagination.</constraint>
    <constraint>**Response format**: Consistent structure with `success`, `data`, `error`, and optional `meta` (total, page, limit) fields.</constraint>
    <constraint>**Input validation**: Use schema validation (e.g., Zod) for all request bodies. Return structured validation errors with 400 status.</constraint>
  </constraints>
</topic>

<topic name="File Organization">
  <constraints>
    <constraint>**Project structure**: Organize by domain — `app/` (routes), `components/` (ui, forms, layouts), `hooks/`, `lib/` (api, utils, constants), `types/`, `styles/`</constraint>
    <constraint>**File naming**: PascalCase for components (`Button.tsx`), camelCase with `use` prefix for hooks (`useAuth.ts`), camelCase for utilities (`formatDate.ts`), camelCase with `.types` suffix for types (`market.types.ts`)</constraint>
  </constraints>
</topic>

<topic name="Comments and Documentation">
  <constraints>
    <constraint>**When to comment**: Explain WHY not WHAT. Comment non-obvious decisions (e.g., "exponential backoff to avoid overwhelming API during outages"). Never state the obvious.</constraint>
    <constraint>**JSDoc**: Use for public APIs with `@param`, `@returns`, `@throws`, and `@example` tags.</constraint>
  </constraints>
</topic>

<topic name="Performance Best Practices">
  <constraints>
    <constraint>**Memoization**: Use `useMemo` for expensive computations, `useCallback` for callbacks passed to children (or let React Compiler handle this in React 19+)</constraint>
    <constraint>**Lazy loading**: Use `lazy()` and `Suspense` for heavy components</constraint>
    <constraint>**Database queries**: Select only needed columns. Never use `select('*')`. Apply limits.</constraint>
  </constraints>
</topic>

<topic name="Testing Standards">
  <constraints>
    <constraint>**AAA Pattern**: Arrange (setup), Act (execute), Assert (verify) in every test</constraint>
    <constraint>**Test naming**: Use descriptive names that state the expected behavior (e.g., "returns empty array when no markets match query")</constraint>
  </constraints>
</topic>

<anti-patterns>
  <anti-pattern>**Long functions**: Functions exceeding 50 lines. Split into smaller, focused functions.</anti-pattern>
  <anti-pattern>**Deep nesting**: 5+ levels of if/else. Use early returns instead.</anti-pattern>
  <anti-pattern>**Magic numbers**: Unexplained numeric literals. Use named constants (`MAX_RETRIES`, `DEBOUNCE_DELAY_MS`).</anti-pattern>
</anti-patterns>
