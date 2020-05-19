import { index } from "../src";

describe('test', () => {
  it('sandbox', () => {
    expect(index()).toBeUndefined();
  });
});