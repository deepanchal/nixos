# Global Agent Instructions

- Never use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Commit changes as separate atomic commits, never one lumped commit. Order by dependency: base/shared code that others import first, then each change that depends on it.
- Never hard-wrap prose or commit message bodies. Write each paragraph as a single continuous line and let the editor soft-wrap.
- When making technical decisions, do not give much weight to development cost. Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- Do not write code comments - no explanatory `//` comments and no `///`/docstring blocks. Make code self-documenting through clear names, small functions, and obvious structure; if a piece of code seems to need a comment, restructure or rename until it doesn't. The only comments allowed are ones the toolchain or workflow requires and that are not explanatory prose: license/codegen headers and functional directives (linter `ignore`/`ignore_for_file`/`noqa`/`eslint-disable`).
