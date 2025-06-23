# Claude Code Custom Commands

This directory contains custom commands and prompt templates for efficient development with Claude Code.

## Usage

### Custom Commands
Use commands by typing `/command-name` in Claude Code:

- `/check-ci` - Check and fix GitHub Actions CI issues
- `/sync-main` - Switch to main branch and pull latest changes
- `/setup-project` - Initialize new TypeScript project
- `/add-feature [name]` - Implement new feature with TDD
- `/fix-coverage` - Improve test coverage to 80%+
- `/optimize-ci` - Optimize CI/CD pipeline performance
- `/create-docs` - Generate/update project documentation
- `/security-audit` - Run security checks and fixes
- `/deploy-prep` - Prepare for deployment

### Prompt Templates
Copy and customize prompts from `prompt-templates.md` for common tasks:

- CI/CD troubleshooting
- Feature implementation
- Project setup
- Maintenance tasks
- Documentation updates

## Best Practices

1. **Always use TodoWrite**: Track complex tasks with clear status
2. **Batch related changes**: Request comprehensive updates in single prompt
3. **Include context**: Provide file paths and specific requirements
4. **Test-driven development**: Request implementation + tests together
5. **Coverage goals**: Maintain 80%+ test coverage
6. **Quality gates**: Ensure lint, typecheck, and tests pass

## Project-Specific Commands

Add project-specific commands by editing `commands.md`:

```markdown
## /my-custom-command

Description of what this command does.

Steps:
1. First step
2. Second step
3. Final step
```

## Integration with CI/CD

These commands work seamlessly with the project's CI/CD pipeline:

- GitHub Actions with self-hosted runner
- Vitest for testing and coverage
- ESLint for code quality
- Automated PR coverage reports

## Performance Targets

- CI pipeline: < 5 minutes
- Test suite: < 30 seconds  
- Build process: < 2 minutes
- Coverage threshold: ≥ 80%