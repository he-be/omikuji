# Templates Directory

This directory contains reusable templates for different aspects of the project.

## GitHub Actions Workflows

### `github-workflows-ci.yml`
Comprehensive CI/CD pipeline template for TypeScript projects.

**Usage:**
```bash
cp templates/github-workflows-ci.yml .github/workflows/ci.yml
# Edit the copied file to match your project needs
```

**Features:**
- Multi-platform builds (Ubuntu, Windows, macOS)
- Security scanning
- Coverage reporting
- Deployment pipeline
- Concurrent execution control

## Project Setup

### `quick-setup.sh`
Automated script to set up a new TypeScript project with CI/CD pipeline.

**Usage:**
```bash
./templates/quick-setup.sh my-new-project
```

**Creates:**
- TypeScript configuration
- Vitest setup
- ESLint configuration
- GitHub Actions workflow
- Basic project structure

## Best Practices

1. **Templates vs Active Files:**
   - Templates in `templates/` directory are NOT executed
   - Active workflows must be in `.github/workflows/`
   - Copy and customize templates as needed

2. **Workflow Naming:**
   - Use descriptive names for active workflows
   - Avoid conflicts between multiple workflows
   - Consider workflow dependencies

3. **Template Maintenance:**
   - Keep templates updated with best practices
   - Test templates in separate projects
   - Document template parameters and customization points