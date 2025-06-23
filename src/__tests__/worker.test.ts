import { describe, test, expect } from 'vitest';
import { getRandomOmikuji, omikujiResults } from '../worker';

// Cloudflare Workers環境をモック
const mockRequest = (url: string, method = 'GET') =>
  new Request(url, { method });

describe('Cloudflare Workers おみくじアプリ', () => {
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
  });

  describe('Worker fetch handler', () => {
    test('should handle root path request', async () => {
      // Dynamic import for worker
      const worker = await import('../worker');
      const request = mockRequest('https://example.com/');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(200);
      expect(response.headers.get('Content-Type')).toContain('text/html');
      
      const html = await response.text();
      expect(html).toContain('<!DOCTYPE html>');
      expect(html).toContain('<title>おみくじ</title>');
      expect(html).toContain('class="result"');
      expect(html).toContain('もう一度引く');
    });

    test('should handle API endpoint', async () => {
      const worker = await import('../worker');
      const request = mockRequest('https://example.com/api/omikuji');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(200);
      expect(response.headers.get('Content-Type')).toBe('application/json');
      expect(response.headers.get('Access-Control-Allow-Origin')).toBe('*');
      
      const json = await response.json() as { result: string };
      expect(omikujiResults).toContain(json.result);
    });

    test('should return 404 for unknown paths', async () => {
      const worker = await import('../worker');
      const request = mockRequest('https://example.com/unknown');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(404);
      expect(await response.text()).toBe('Not Found');
    });

    test('should include proper cache headers for HTML', async () => {
      const worker = await import('../worker');
      const request = mockRequest('https://example.com/');
      
      const response = await worker.default.fetch(request);
      
      expect(response.headers.get('Cache-Control')).toBe('no-cache');
    });

    test('should return valid omikuji results in HTML', async () => {
      const worker = await import('../worker');
      const request = mockRequest('https://example.com/');
      
      const response = await worker.default.fetch(request);
      const html = await response.text();
      
      // HTMLから結果を抽出
      const resultMatch = html.match(/<div class="result">([^<]+)<\/div>/);
      expect(resultMatch).toBeTruthy();
      
      if (resultMatch) {
        const result = resultMatch[1];
        expect(omikujiResults).toContain(result);
      }
    });
  });
});