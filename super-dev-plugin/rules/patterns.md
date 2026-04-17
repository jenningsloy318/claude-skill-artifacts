<meta>
  <name>patterns</name>
  <type>rule</type>
  <description>Common patterns for API responses, custom hooks, repository pattern, and skeleton projects</description>
</meta>

<purpose>Define standard patterns for API responses, custom hooks, data access, and new project initialization.</purpose>

<directives>
  <directive severity="high">**API Response Format**: Consistent structure with `success` (boolean), `data` (optional), `error` (optional string), and `meta` (optional: total, page, limit)</directive>
  <directive severity="high">**Custom Hooks Pattern**: Extract reusable stateful logic into hooks (e.g., `useDebounce` with useState + useEffect + setTimeout/clearTimeout)</directive>
  <directive severity="high">**Repository Pattern**: Abstract data access behind interfaces with findAll, findById, create, update, delete methods. Use generics for type safety.</directive>
  <directive severity="medium">**Skeleton Projects**: When implementing new functionality, search for battle-tested skeleton projects, evaluate options in parallel (security, extensibility, relevance, implementation plan), clone best match as foundation, iterate within proven structure.</directive>
</directives>
