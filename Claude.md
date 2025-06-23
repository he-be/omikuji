# AI Development Constitution (CLAUDE.md)

This document contains the core rules and principles for AI-driven development in this project. You MUST follow all rules listed here when you write or modify code, create commits, or perform any other development task.

---

## 1. Core Development Rules (中核となる開発ルール)

### 1.1. Language and Style
- All code MUST be written in TypeScript.
- Code style MUST strictly adhere to the project's `.eslintrc.js` and `.prettierrc` configurations. Run the linter/formatter before finalizing your changes.

### 1.2. Type Safety
- All function arguments, return values, and variable declarations MUST have explicit type definitions.
- The use of `any` is strictly forbidden. If a type cannot be determined, use `unknown` and perform type checking.

### 1.3. Modularity and Function Design
- Functions MUST be small and adhere to the Single Responsibility Principle (SRP). A single function should ideally be no longer than 50 lines.
- Create pure functions whenever possible. Avoid side effects.

### 1.4. Documentation
- All exported functions, classes, and types MUST have JSDoc comments.
- The JSDoc should explain the purpose of the code, all parameters (`@param`), and the return value (`@returns`).

### 1.5. Error Handling
- Potentially failing operations (e.g., API calls, file I/O) MUST be wrapped in `try...catch` blocks.
- Do not use generic `Error`. Create custom error classes or use specific error types where appropriate.

---

## 2. Testing Requirements (テスト要件)

### 2.1. Test Strategy
- Every new feature or bug fix MUST be accompanied by corresponding unit tests using Vitest.
- Business logic MUST be tested independently from the UI framework.

### 2.2. Test Coverage
- The overall test coverage MUST be maintained at 85% or higher for lines, branches, and functions.
- You are not allowed to submit code that decreases the overall test coverage.

### 2.3. Test Implementation
- Test files MUST be co-located with the source files they are testing, using the `.spec.ts` suffix. (e.g., `utils.ts` and `utils.spec.ts`).
- Mock dependencies to ensure tests are isolated and fast.

---

## 3. GitHub Usage Rules (GitHub利用ルール)

### 3.1. Branch Naming Convention
- Branch names MUST follow the pattern: `type/short-description`.
- `type` can be one of: `feature`, `fix`, `refactor`, `chore`, `docs`.
- Example: `feature/user-authentication`

### 3.2. Commit Message Convention
- Commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.
- Format: `<type>(<scope>): <subject>`
- Example: `feat(auth): implement password hashing with argon2`

### 3.3. Pull Request (PR) Convention
- The PR title MUST also follow the Conventional Commits format.
- The PR body MUST include a link to the issue it resolves, using the `Closes #<issue-number>` keyword.
- All PRs MUST include the Claude Code footer:
  ```
  🤖 Generated with [Claude Code](https://claude.ai/code)
  
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

---

## 4. Claude Code Workflow Optimization (Claude Code ワークフロー最適化)

### 4.1. Efficient Task Management
- Use TodoWrite and TodoRead tools FREQUENTLY to track progress and ensure no tasks are missed.
- Break complex tasks into smaller, manageable todos with clear status tracking.
- Mark todos as completed IMMEDIATELY after finishing each task.

### 4.2. Batch Processing
- ❌ **Avoid**: Making multiple separate requests for related changes
- ✅ **Prefer**: Request comprehensive changes in a single prompt
- Example: "Set up TypeScript project with Vitest testing, ESLint, CI/CD pipeline, and initial tests"

### 4.3. Context-Aware Prompting
- Always provide sufficient context about the project structure and requirements
- Include specific file paths and expected functionality
- Example: "Add tests for src/api/users.ts including error cases and edge cases"

### 4.4. Test-Driven Development
- Request both implementation AND tests in a single prompt
- Aim for 80%+ coverage in all new code
- Example: "Implement user authentication API with JWT tokens. Include comprehensive tests."

---

## 5. CI/CD Pipeline Requirements (CI/CD パイプライン要件)

### 5.1. Test Framework Configuration
- MUST use Vitest as the primary test runner (not Jest)
- Coverage configuration MUST include all required reporters:
  ```typescript
  // vitest.config.ts
  reporter: ['text', 'json', 'json-summary', 'html']
  ```

### 5.2. GitHub Actions Setup
- CI pipeline MUST include these stages in order:
  1. Code quality checks (lint, typecheck)
  2. Unit tests with coverage
  3. Build verification
  4. Coverage reporting to PR
- Use self-hosted runners when available for better performance
- MUST set GitHub Actions permissions to "Read and write permissions" for coverage reports

### 5.3. Testable Code Structure
- All main application code MUST be exportable for testing:
  ```typescript
  export const app = express();
  export function myFunction() { /* ... */ }
  
  // Only start server when run directly
  if (require.main === module) {
    app.listen(port);
  }
  ```

### 5.4. Coverage Requirements
- Minimum 80% code coverage for all new code
- PRs MUST NOT decrease overall coverage
- Coverage reports MUST be automatically posted to PRs

---

## 6. Project-Specific Requirements (このプロジェクト固有の要件)

### 6.1. Technology Stack
- **Runtime**: Node.js 20.x
- **Language**: TypeScript 5.x
- **Test Framework**: Vitest with @vitest/coverage-v8
- **HTTP Testing**: supertest for API testing
- **CI/CD**: GitHub Actions with self-hosted runner

### 6.2. Project Structure
```
src/
├── __tests__/          # Test files
├── index.ts           # Main application entry
└── ...
.github/workflows/     # CI/CD workflows
docs/                  # Documentation
templates/             # Reusable templates
```

### 6.3. Development Commands
- `npm run test` - Run all tests
- `npm run test:coverage` - Generate coverage report
- `npm run lint` - Run ESLint
- `npm run typecheck` - TypeScript type checking
- `npm run build` - Build for production

### 6.4. Quality Gates
- All code MUST pass TypeScript strict mode compilation
- ESLint MUST show zero errors
- Test coverage MUST be ≥80%
- All GitHub Actions checks MUST pass

### 6.5. Performance Targets
- CI pipeline MUST complete in under 5 minutes
- Test suite MUST complete in under 30 seconds
- Build process MUST complete in under 2 minutes