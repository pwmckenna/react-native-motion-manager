let handler = {
    get: function (target, name) {
        if (name in target) {
            return target[name];
        }
        let noOp = jest.fn();
        target[name] = noOp;
        return noOp;
    }
};

/**
 * Creates mock objects who always has a requested property that is a function mock.
 */
export default class NoOpMock {
    constructor() {
    }

    static newMock() {
        return new Proxy(jest.fn(), handler);
    }
}