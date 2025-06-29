import { test, expect } from '@playwright/test';

test.describe('Omikuji Application E2E Tests', () => {
  test('should display omikuji page with valid result', async ({ page }) => {
    // Navigate to the omikuji page
    await page.goto('/');

    // Check page title
    await expect(page).toHaveTitle('おみくじ');

    // Check that the page contains an omikuji result
    const resultElement = page.locator('.result');
    await expect(resultElement).toBeVisible();

    // Check that the result is one of the valid omikuji results
    const resultText = await resultElement.textContent();
    expect(resultText).toMatch(/^(大凶|凶|小吉|吉|大吉)$/);

    // Check that the "try again" link is present and clickable
    const tryAgainLink = page.locator('a:has-text("もう一度引く")');
    await expect(tryAgainLink).toBeVisible();
    await expect(tryAgainLink).toHaveAttribute('href', '/');
  });

  test('should be able to draw omikuji multiple times', async ({ page }) => {
    await page.goto('/');

    // Click "try again" link
    await page.click('a:has-text("もう一度引く")');

    // Wait for page to reload and check that we have a result
    await page.waitForLoadState('networkidle');
    const resultElement = page.locator('.result');
    await expect(resultElement).toBeVisible();

    // Verify the new result is valid (may be same or different)
    const newResult = await resultElement.textContent();
    expect(newResult).toMatch(/^(大凶|凶|小吉|吉|大吉)$/);
  });

  test('should return valid JSON from API endpoint', async ({ page }) => {
    // Make a direct request to the API endpoint
    const response = await page.request.get('/api/omikuji');

    expect(response.status()).toBe(200);
    expect(response.headers()['content-type']).toBe('application/json');
    expect(response.headers()['access-control-allow-origin']).toBe('*');

    const jsonData = await response.json();
    expect(jsonData).toHaveProperty('result');
    expect(jsonData.result).toMatch(/^(大凶|凶|小吉|吉|大吉)$/);
  });

  test('should return 404 for unknown paths', async ({ page }) => {
    const response = await page.request.get('/unknown-path');
    expect(response.status()).toBe(404);
    expect(await response.text()).toBe('Not Found');
  });

  test('should have proper cache headers', async ({ page }) => {
    const response = await page.request.get('/');
    expect(response.status()).toBe(200);
    expect(response.headers()['cache-control']).toBe('no-cache');
    expect(response.headers()['content-type']).toContain('text/html');
  });
});
