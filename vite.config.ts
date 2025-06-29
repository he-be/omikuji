import { defineConfig } from 'vite'
import { defineConfig as defineVitestConfig } from 'vitest/config'

// Merge Vite and Vitest configs
export default defineConfig(
  defineVitestConfig({
    test: {
      globals: true,
      environment: 'node',
      coverage: {
        provider: 'v8',
        reporter: ['text', 'json', 'json-summary', 'html'],
        reportsDirectory: './coverage',
        exclude: [
          'node_modules/',
          'dist/',
          '**/*.d.ts',
          '**/*.config.*',
          'coverage/**'
        ]
      }
    },
    build: {
      target: 'es2022',
      outDir: 'dist',
      emptyOutDir: true,
      minify: true,
      rollupOptions: {
        input: './src/index.ts',
        output: {
          format: 'es'
        }
      }
    },
    resolve: {
      alias: {
        '@': '/src'
      }
    }
  })
)