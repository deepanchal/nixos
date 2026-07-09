# Global Agent Instructions

- Never use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Commit changes as separate atomic commits, never one lumped commit. Order by dependency: base/shared code that others import first, then each change that depends on it.
- Never hard-wrap prose or commit message bodies. Write each paragraph as a single continuous line and let the editor soft-wrap.
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- Write self-documenting code via clear names. Comment only to explain *why* (rationale, tradeoffs, workarounds, footguns, non-standard patterns), never to restate *what* the code does. Keep docstrings and required headers.
