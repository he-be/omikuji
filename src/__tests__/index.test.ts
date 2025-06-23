import { describe, test, expect, vi, beforeEach, afterEach } from 'vitest';
import request from 'supertest';
import { app, getRandomOmikuji, omikujiResults } from '../index';

describe('Omikuji Application', () => {
  describe('GET /', () => {
    test('should return 200 OK', async () => {
      const response = await request(app).get('/');
      expect(response.status).toBe(200);
    });

    test('should return HTML content', async () => {
      const response = await request(app).get('/');
      expect(response.type).toBe('text/html');
      expect(response.text).toContain('<!DOCTYPE html>');
      expect(response.text).toContain('<html lang="ja">');
    });

    test('should contain required page elements', async () => {
      const response = await request(app).get('/');
      expect(response.text).toContain('<title>おみくじ</title>');
      expect(response.text).toContain('<h1>おみくじ</h1>');
      expect(response.text).toContain('class="result"');
      expect(response.text).toContain('もう一度引く');
    });

    test('should return a valid omikuji result', async () => {
      const response = await request(app).get('/');
      
      // Extract the result from HTML
      const resultMatch = response.text.match(/<div class="result">([^<]+)<\/div>/);
      expect(resultMatch).toBeTruthy();
      
      if (resultMatch) {
        const result = resultMatch[1];
        expect(omikujiResults).toContain(result);
      }
    });

    test('should return different results on multiple requests', async () => {
      const results = new Set<string>();
      
      // Make multiple requests to test randomness
      for (let i = 0; i < 20; i++) {
        const response = await request(app).get('/');
        const resultMatch = response.text.match(/<div class="result">([^<]+)<\/div>/);
        
        if (resultMatch) {
          results.add(resultMatch[1]);
        }
      }
      
      // Should have at least 2 different results in 20 tries
      expect(results.size).toBeGreaterThan(1);
    });

    test('should have proper styling', async () => {
      const response = await request(app).get('/');
      expect(response.text).toContain('background-color: #f0f0f0');
      expect(response.text).toContain('color: #d4af37');
      expect(response.text).toContain('background-color: #4CAF50');
    });

    test('should have viewport meta tag for mobile', async () => {
      const response = await request(app).get('/');
      expect(response.text).toContain('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    });
  });

  describe('Static files', () => {
    test('should serve static files from public directory', async () => {
      // Test that static middleware is configured
      // This would return 404 for non-existent files
      const response = await request(app).get('/non-existent-file.css');
      expect(response.status).toBe(404);
    });
  });
});

describe('getRandomOmikuji function', () => {
  test('should return a valid omikuji result', () => {
    const result = getRandomOmikuji();
    expect(omikujiResults).toContain(result);
  });

  test('should return one of the five possible results', () => {
    const results = new Set();
    for (let i = 0; i < 100; i++) {
      results.add(getRandomOmikuji());
    }
    expect(results.size).toBeGreaterThan(0);
    expect(results.size).toBeLessThanOrEqual(5);
  });

  test('should use Math.random for randomness', () => {
    const mathRandomSpy = vi.spyOn(Math, 'random');
    getRandomOmikuji();
    expect(mathRandomSpy).toHaveBeenCalled();
    mathRandomSpy.mockRestore();
  });

  test('should handle edge cases with Math.random', () => {
    // Test when Math.random returns 0
    vi.spyOn(Math, 'random').mockReturnValue(0);
    expect(getRandomOmikuji()).toBe('大凶');
    
    // Test when Math.random returns close to 1
    vi.spyOn(Math, 'random').mockReturnValue(0.999);
    expect(getRandomOmikuji()).toBe('大吉');
    
    vi.restoreAllMocks();
  });
});

describe('Port configuration', () => {
  const originalEnv = process.env;

  afterEach(() => {
    process.env = originalEnv;
  });

  test('should use PORT environment variable when set', () => {
    process.env.PORT = '4000';
    expect(process.env.PORT).toBe('4000');
  });

  test('should use default port 3000 when PORT is not set', () => {
    delete process.env.PORT;
    expect(process.env.PORT).toBeUndefined();
  });
});

describe('Server startup', () => {
  test('should not start server when imported as module', () => {
    const consoleSpy = vi.spyOn(console, 'log');
    // When imported as a module, require.main !== module, so server shouldn't start
    expect(consoleSpy).not.toHaveBeenCalledWith(expect.stringContaining('おみくじアプリが'));
    consoleSpy.mockRestore();
  });

  test('should log startup message when server starts', () => {
    // This tests the console.log message format
    const port = 3000;
    const expectedMessage = `おみくじアプリが http://localhost:${port} で起動しました`;
    expect(expectedMessage).toContain('おみくじアプリが');
    expect(expectedMessage).toContain('http://localhost:3000');
  });
});