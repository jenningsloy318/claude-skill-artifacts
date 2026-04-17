<meta>
  <name>frontend-patterns</name>
  <type>template</type>
  <description>Frontend development patterns for React 19, Next.js 16, state management, performance optimization, and UI best practices</description>
</meta>

<purpose>Modern frontend patterns for React, Next.js, and performant user interfaces covering component design, custom hooks, state management, performance optimization, form handling, error boundaries, animation, and accessibility.</purpose>

<pattern name="Component Patterns">
  <principles>
    <principle name="Composition Over Inheritance">Build complex UI by composing smaller components (Card + CardHeader + CardBody) rather than extending base classes</principle>
    <principle name="Compound Components">Use React Context to create related component families that share implicit state (e.g., Tabs + TabList + Tab sharing activeTab context)</principle>
    <principle name="Render Props">Pass data to children via function props for flexible rendering (e.g., DataLoader providing data/loading/error to child function)</principle>
  </principles>
</pattern>

<pattern name="Custom Hooks Patterns">
  <constraints>
    <constraint name="State management hooks">Extract toggle, counter, and similar state logic into reusable hooks (e.g., `useToggle` returning `[value, toggle]`)</constraint>
    <constraint name="Async data fetching">Create `useQuery`-style hooks with data/error/loading/refetch state, supporting `onSuccess`/`onError` callbacks and `enabled` flag</constraint>
    <constraint name="Debounce hook">Implement `useDebounce(value, delay)` using `useState` and `useEffect` with `setTimeout`/`clearTimeout` for search inputs</constraint>
  </constraints>
</pattern>

<pattern name="State Management">
  <constraints>
    <constraint name="Context + Reducer">For complex shared state, combine `useReducer` with Context. Define typed State and Action types, create a Provider component, and expose a custom hook (e.g., `useMarkets`) that throws if used outside Provider.</constraint>
  </constraints>
</pattern>

<pattern name="Performance Optimization">
  <constraints>
    <constraint name="React 19 + Compiler 1.0">Write plain code — the compiler auto-memoizes components and hooks at build time. Avoid manual `useMemo`/`useCallback`/`React.memo` unless profiling shows compiler misses a specific case.</constraint>
    <constraint name="Code splitting">Use `lazy()` and `Suspense` with meaningful fallbacks (skeletons, not spinners) for heavy components</constraint>
    <constraint name="Virtualization">For long lists (100+ items), use `@tanstack/react-virtual` with `useVirtualizer` for estimated row heights and overscan</constraint>
  </constraints>
</pattern>

<pattern name="Form Handling">
  <constraints>
    <constraint name="Controlled forms">Use state for form data and errors. Validate on submit with explicit field-by-field checks. Return early if validation fails. Handle both success and error paths in submit handler.</constraint>
  </constraints>
</pattern>

<pattern name="Error Boundaries">
  <constraints>
    <constraint name="Error boundary pattern">Use class component with `getDerivedStateFromError` and `componentDidCatch`. Render fallback UI with error message and retry button. Wrap top-level app and critical sections.</constraint>
  </constraints>
</pattern>

<pattern name="Animation Patterns">
  <constraints>
    <constraint name="Framer Motion">Use `AnimatePresence` for enter/exit animations. Apply `initial`/`animate`/`exit` props. Use for list animations (opacity + y offset) and modal animations (opacity + scale + y offset).</constraint>
  </constraints>
</pattern>

<pattern name="Accessibility Patterns">
  <constraints>
    <constraint name="Keyboard navigation">Implement `onKeyDown` handlers for ArrowDown/ArrowUp (navigate), Enter (select), Escape (close). Use `role`, `aria-expanded`, `aria-haspopup` attributes on interactive containers.</constraint>
    <constraint name="Focus management">Save `document.activeElement` before opening modals/dialogs, focus the modal on open, restore previous focus on close. Use `role="dialog"`, `aria-modal="true"`, `tabIndex={-1}` on modal containers.</constraint>
  </constraints>
</pattern>

<references>
  <ref>Covers React 19, Next.js 16, React Compiler 1.0, Framer Motion, @tanstack/react-virtual</ref>
</references>
