import { describe, test, expect } from 'vitest';

describe('Omikuji', () => {
  const omikujiResults = ['大凶', '凶', '小吉', '吉', '大吉'];

  function getRandomOmikuji(): string {
    const randomIndex = Math.floor(Math.random() * omikujiResults.length);
    return omikujiResults[randomIndex];
  }

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