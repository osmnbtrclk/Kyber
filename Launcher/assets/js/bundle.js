(() => {
    // node_modules/@bbob/plugin-helper/es/char.js
    var N = "\n";
    var TAB = "	";
    var EQ = "=";
    var QUOTEMARK = '"';
    var SPACE = " ";
    var OPEN_BRAKET = "[";
    var CLOSE_BRAKET = "]";
    var SLASH = "/";
    var BACKSLASH = "\\";

    // node_modules/@bbob/plugin-helper/es/helpers.js
    function isTagNode(el) {
        return typeof el === "object" && el !== null && "tag" in el;
    }

    function isStringNode(el) {
        return typeof el === "string";
    }

    function keysReduce(obj, reduce, def) {
        const keys = Object.keys(obj);
        return keys.reduce((acc, key) => reduce(acc, key, obj), def);
    }

    function getNodeLength(node) {
        if (isTagNode(node) && Array.isArray(node.content)) {
            return node.content.reduce((count, contentNode) => {
                return count + getNodeLength(contentNode);
            }, 0);
        }
        if (isStringNode(node)) {
            return String(node).length;
        }
        return 0;
    }

    function appendToNode(node, value) {
        if (Array.isArray(node.content)) {
            node.content.push(value);
        }
    }

    function escapeAttrValue(value) {
        return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;").replace(/(javascript|data|vbscript):/gi, "$1%3A");
    }

    function attrValue(name, value) {
        switch (typeof value) {
            case "boolean":
                return value ? `${name}` : "";
            case "number":
                return `${name}="${value}"`;
            case "string":
                return `${name}="${escapeAttrValue(value)}"`;
            case "object":
                return `${name}="${escapeAttrValue(JSON.stringify(value))}"`;
            default:
                return "";
        }
    }

    function attrsToString(values) {
        if (values == null) {
            return "";
        }
        return keysReduce(values, (arr, key, obj) => [
            ...arr,
            attrValue(key, obj[key])
        ], [
            ""
        ]).join(" ");
    }

    function getUniqAttr(attrs) {
        return keysReduce(attrs || {}, (res, key, obj) => obj[key] === key ? obj[key] : null, null);
    }

    // node_modules/@bbob/plugin-helper/es/TagNode.js
    var getTagAttrs = (tag, params) => {
        const uniqAttr = getUniqAttr(params);
        if (uniqAttr) {
            const tagAttr = attrValue(tag, uniqAttr);
            const attrs = {
                ...params
            };
            delete attrs[String(uniqAttr)];
            const attrsStr = attrsToString(attrs);
            return `${tagAttr}${attrsStr}`;
        }
        return `${tag}${attrsToString(params)}`;
    };
    var renderContent = (content, openTag, closeTag) => {
        const toString = (node) => {
            if (isTagNode(node)) {
                return node.toString({
                    openTag,
                    closeTag
                });
            }
            return String(node);
        };
        if (Array.isArray(content)) {
            return content.reduce((r, node) => {
                if (node !== null) {
                    return r + toString(node);
                }
                return r;
            }, "");
        }
        if (content) {
            return toString(content);
        }
        return null;
    };
    var TagNode = class _TagNode {
        attr(name, value) {
            if (typeof value !== "undefined") {
                this.attrs[name] = value;
            }
            return this.attrs[name];
        }

        append(value) {
            return appendToNode(this, value);
        }

        setStart(value) {
            this.start = value;
        }

        setEnd(value) {
            this.end = value;
        }

        get length() {
            return getNodeLength(this);
        }

        toTagStart({openTag = OPEN_BRAKET, closeTag = CLOSE_BRAKET} = {}) {
            const tagAttrs = getTagAttrs(String(this.tag), this.attrs);
            return `${openTag}${tagAttrs}${closeTag}`;
        }

        toTagEnd({openTag = OPEN_BRAKET, closeTag = CLOSE_BRAKET} = {}) {
            return `${openTag}${SLASH}${this.tag}${closeTag}`;
        }

        toTagNode() {
            const newNode = new _TagNode(String(this.tag).toLowerCase(), this.attrs, this.content);
            if (this.start) {
                newNode.setStart(this.start);
            }
            if (this.end) {
                newNode.setEnd(this.end);
            }
            return newNode;
        }

        toString({openTag = OPEN_BRAKET, closeTag = CLOSE_BRAKET} = {}) {
            const content = this.content ? renderContent(this.content, openTag, closeTag) : "";
            const tagStart = this.toTagStart({
                openTag,
                closeTag
            });
            if (this.content === null || Array.isArray(this.content) && this.content.length === 0) {
                return tagStart;
            }
            return `${tagStart}${content}${this.toTagEnd({
                openTag,
                closeTag
            })}`;
        }

        static create(tag, attrs = {}, content = null, start) {
            const node = new _TagNode(tag, attrs, content);
            if (start) {
                node.setStart(start);
            }
            return node;
        }

        static isOf(node, type) {
            return node.tag === type;
        }

        constructor(tag, attrs, content) {
            this.tag = tag;
            this.attrs = attrs;
            this.content = content;
        }
    };

    // node_modules/@bbob/parser/es/Token.js
    var TOKEN_TYPE_ID = "t";
    var TOKEN_VALUE_ID = "v";
    var TOKEN_COLUMN_ID = "r";
    var TOKEN_LINE_ID = "l";
    var TOKEN_START_POS_ID = "s";
    var TOKEN_END_POS_ID = "e";
    var TOKEN_TYPE_WORD = 1;
    var TOKEN_TYPE_TAG = 2;
    var TOKEN_TYPE_ATTR_NAME = 3;
    var TOKEN_TYPE_ATTR_VALUE = 4;
    var TOKEN_TYPE_SPACE = 5;
    var TOKEN_TYPE_NEW_LINE = 6;
    var getTokenValue = (token) => {
        if (token && typeof token[TOKEN_VALUE_ID] !== "undefined") {
            return token[TOKEN_VALUE_ID];
        }
        return "";
    };
    var getTokenLine = (token) => token && token[TOKEN_LINE_ID] || 0;
    var getTokenColumn = (token) => token && token[TOKEN_COLUMN_ID] || 0;
    var getStartPosition = (token) => token && token[TOKEN_START_POS_ID] || 0;
    var getEndPosition = (token) => token && token[TOKEN_END_POS_ID] || 0;
    var isTextToken = (token) => {
        if (token && typeof token[TOKEN_TYPE_ID] !== "undefined") {
            return token[TOKEN_TYPE_ID] === TOKEN_TYPE_SPACE || token[TOKEN_TYPE_ID] === TOKEN_TYPE_NEW_LINE || token[TOKEN_TYPE_ID] === TOKEN_TYPE_WORD;
        }
        return false;
    };
    var isTagToken = (token) => {
        if (token && typeof token[TOKEN_TYPE_ID] !== "undefined") {
            return token[TOKEN_TYPE_ID] === TOKEN_TYPE_TAG;
        }
        return false;
    };
    var isTagEnd = (token) => getTokenValue(token).charCodeAt(0) === SLASH.charCodeAt(0);
    var isTagStart = (token) => !isTagEnd(token);
    var isAttrNameToken = (token) => {
        if (token && typeof token[TOKEN_TYPE_ID] !== "undefined") {
            return token[TOKEN_TYPE_ID] === TOKEN_TYPE_ATTR_NAME;
        }
        return false;
    };
    var isAttrValueToken = (token) => {
        if (token && typeof token[TOKEN_TYPE_ID] !== "undefined") {
            return token[TOKEN_TYPE_ID] === TOKEN_TYPE_ATTR_VALUE;
        }
        return false;
    };
    var getTagName = (token) => {
        const value = getTokenValue(token);
        return isTagEnd(token) ? value.slice(1) : value;
    };
    var tokenToText = (token) => {
        let text = OPEN_BRAKET;
        text += getTokenValue(token);
        text += CLOSE_BRAKET;
        return text;
    };
    var Token = class {
        get type() {
            return this[TOKEN_TYPE_ID];
        }

        isEmpty() {
            return this[TOKEN_TYPE_ID] === 0 || isNaN(this[TOKEN_TYPE_ID]);
        }

        isText() {
            return isTextToken(this);
        }

        isTag() {
            return isTagToken(this);
        }

        isAttrName() {
            return isAttrNameToken(this);
        }

        isAttrValue() {
            return isAttrValueToken(this);
        }

        isStart() {
            return isTagStart(this);
        }

        isEnd() {
            return isTagEnd(this);
        }

        getName() {
            return getTagName(this);
        }

        getValue() {
            return getTokenValue(this);
        }

        getLine() {
            return getTokenLine(this);
        }

        getColumn() {
            return getTokenColumn(this);
        }

        getStart() {
            return getStartPosition(this);
        }

        getEnd() {
            return getEndPosition(this);
        }

        toString() {
            return tokenToText(this);
        }

        constructor(type, value, row = 0, col = 0, start = 0, end = 0) {
            this[TOKEN_LINE_ID] = row;
            this[TOKEN_COLUMN_ID] = col;
            this[TOKEN_TYPE_ID] = type || 0;
            this[TOKEN_VALUE_ID] = String(value);
            this[TOKEN_START_POS_ID] = start;
            this[TOKEN_END_POS_ID] = end;
        }
    };
    var TYPE_WORD = TOKEN_TYPE_WORD;
    var TYPE_TAG = TOKEN_TYPE_TAG;
    var TYPE_ATTR_NAME = TOKEN_TYPE_ATTR_NAME;
    var TYPE_ATTR_VALUE = TOKEN_TYPE_ATTR_VALUE;
    var TYPE_SPACE = TOKEN_TYPE_SPACE;
    var TYPE_NEW_LINE = TOKEN_TYPE_NEW_LINE;

    // node_modules/@bbob/parser/es/utils.js
    var CharGrabber = class {
        skip(num = 1, silent) {
            this.c.pos += num;
            if (this.o && this.o.onSkip && !silent) {
                this.o.onSkip();
            }
        }

        hasNext() {
            return this.c.len > this.c.pos;
        }

        getCurr() {
            if (typeof this.s[this.c.pos] === "undefined") {
                return "";
            }
            return this.s[this.c.pos];
        }

        getPos() {
            return this.c.pos;
        }

        getLength() {
            return this.c.len;
        }

        getRest() {
            return this.s.substring(this.c.pos);
        }

        getNext() {
            const nextPos = this.c.pos + 1;
            return nextPos <= this.s.length - 1 ? this.s[nextPos] : null;
        }

        getPrev() {
            const prevPos = this.c.pos - 1;
            if (typeof this.s[prevPos] === "undefined") {
                return null;
            }
            return this.s[prevPos];
        }

        isLast() {
            return this.c.pos === this.c.len;
        }

        includes(val) {
            return this.s.indexOf(val, this.c.pos) >= 0;
        }

        grabWhile(condition, silent) {
            let start = 0;
            if (this.hasNext()) {
                start = this.c.pos;
                while (this.hasNext() && condition(this.getCurr())) {
                    this.skip(1, silent);
                }
            }
            return this.s.substring(start, this.c.pos);
        }

        grabN(num = 0) {
            return this.s.substring(this.c.pos, this.c.pos + num);
        }

        /**
         * Grabs rest of string until it find a char
         */
        substrUntilChar(char) {
            const {pos} = this.c;
            const idx = this.s.indexOf(char, pos);
            return idx >= 0 ? this.s.substring(pos, idx) : "";
        }

        constructor(source, options = {}) {
            this.s = source;
            this.c = {
                pos: 0,
                len: source.length
            };
            this.o = options;
        }
    };
    var createCharGrabber = (source, options) => new CharGrabber(source, options);
    var trimChar = (str, charToRemove) => {
        while (str.charAt(0) === charToRemove) {
            str = str.substring(1);
        }
        while (str.charAt(str.length - 1) === charToRemove) {
            str = str.substring(0, str.length - 1);
        }
        return str;
    };
    var unquote = (str) => str.replace(BACKSLASH + QUOTEMARK, QUOTEMARK);

    // node_modules/@bbob/parser/es/lexer.js
    var EM = "!";

    function createTokenOfType(type, value, r = 0, cl = 0, p = 0, e = 0) {
        return new Token(type, value, r, cl, p, e);
    }

    var STATE_WORD = 0;
    var STATE_TAG = 1;
    var STATE_TAG_ATTRS = 2;
    var TAG_STATE_NAME = 0;
    var TAG_STATE_ATTR = 1;
    var TAG_STATE_VALUE = 2;
    var WHITESPACES = [
        SPACE,
        TAB
    ];
    var SPECIAL_CHARS = [
        EQ,
        SPACE,
        TAB
    ];
    var END_POS_OFFSET = 2;
    var isWhiteSpace = (char) => WHITESPACES.indexOf(char) >= 0;
    var isEscapeChar = (char) => char === BACKSLASH;
    var isSpecialChar = (char) => SPECIAL_CHARS.indexOf(char) >= 0;
    var isNewLine = (char) => char === N;
    var unq = (val) => unquote(trimChar(val, QUOTEMARK));

    function createLexer(buffer, options = {}) {
        let row = 0;
        let prevCol = 0;
        let col = 0;
        let tokenIndex = -1;
        let stateMode = STATE_WORD;
        let tagMode = TAG_STATE_NAME;
        let contextFreeTag = "";
        const tokens = new Array(Math.floor(buffer.length));
        const openTag = options.openTag || OPEN_BRAKET;
        const closeTag = options.closeTag || CLOSE_BRAKET;
        const escapeTags = !!options.enableEscapeTags;
        const contextFreeTags = (options.contextFreeTags || []).filter(Boolean).map((tag) => tag.toLowerCase());
        const nestedMap = /* @__PURE__ */ new Map();
        const onToken = options.onToken || (() => {
        });
        const RESERVED_CHARS = [
            closeTag,
            openTag,
            QUOTEMARK,
            BACKSLASH,
            SPACE,
            TAB,
            EQ,
            N,
            EM
        ];
        const NOT_CHAR_TOKENS = [
            openTag,
            SPACE,
            TAB,
            N
        ];
        const isCharReserved = (char) => RESERVED_CHARS.indexOf(char) >= 0;
        const isCharToken = (char) => NOT_CHAR_TOKENS.indexOf(char) === -1;
        const isEscapableChar = (char) => char === openTag || char === closeTag || char === BACKSLASH;
        const onSkip = () => {
            col++;
        };
        const checkContextFreeMode = (name, isClosingTag) => {
            if (contextFreeTag !== "" && isClosingTag) {
                contextFreeTag = "";
            }
            if (contextFreeTag === "" && contextFreeTags.includes(name.toLowerCase())) {
                contextFreeTag = name;
            }
        };
        const chars = createCharGrabber(buffer, {
            onSkip
        });

        function emitToken(type, value, startPos, endPos) {
            const token = createTokenOfType(type, value, row, prevCol, startPos, endPos);
            onToken(token);
            prevCol = col;
            tokenIndex += 1;
            tokens[tokenIndex] = token;
        }

        function nextTagState(tagChars, isSingleValueTag, masterStartPos) {
            if (tagMode === TAG_STATE_ATTR) {
                const validAttrName = (char) => !(char === EQ || isWhiteSpace(char));
                const name2 = tagChars.grabWhile(validAttrName);
                const isEnd = tagChars.isLast();
                const isValue = tagChars.getCurr() !== EQ;
                tagChars.skip();
                if (isEnd || isValue) {
                    emitToken(TYPE_ATTR_VALUE, unq(name2));
                } else {
                    emitToken(TYPE_ATTR_NAME, name2);
                }
                if (isEnd) {
                    return TAG_STATE_NAME;
                }
                if (isValue) {
                    return TAG_STATE_ATTR;
                }
                return TAG_STATE_VALUE;
            }
            if (tagMode === TAG_STATE_VALUE) {
                let stateSpecial = false;
                const validAttrValue = (char) => {
                    const isQM = char === QUOTEMARK;
                    const prevChar = tagChars.getPrev();
                    const nextChar = tagChars.getNext();
                    const isPrevSLASH = prevChar === BACKSLASH;
                    const isNextEQ = nextChar === EQ;
                    const isWS = isWhiteSpace(char);
                    const isNextWS = nextChar && isWhiteSpace(nextChar);
                    if (stateSpecial && isSpecialChar(char)) {
                        return true;
                    }
                    if (isQM && !isPrevSLASH) {
                        stateSpecial = !stateSpecial;
                        if (!stateSpecial && !(isNextEQ || isNextWS)) {
                            return false;
                        }
                    }
                    if (!isSingleValueTag) {
                        return !isWS;
                    }
                    return true;
                };
                const name2 = tagChars.grabWhile(validAttrValue);
                tagChars.skip();
                emitToken(TYPE_ATTR_VALUE, unq(name2));
                if (tagChars.getPrev() === QUOTEMARK) {
                    prevCol++;
                }
                if (tagChars.isLast()) {
                    return TAG_STATE_NAME;
                }
                return TAG_STATE_ATTR;
            }
            const start = masterStartPos + tagChars.getPos() - 1;
            const validName = (char) => !(char === EQ || isWhiteSpace(char) || tagChars.isLast());
            const name = tagChars.grabWhile(validName);
            emitToken(TYPE_TAG, name, start, masterStartPos + tagChars.getLength() + 1);
            checkContextFreeMode(name);
            tagChars.skip();
            prevCol++;
            if (isSingleValueTag) {
                return TAG_STATE_VALUE;
            }
            const hasEQ = tagChars.includes(EQ);
            return hasEQ ? TAG_STATE_ATTR : TAG_STATE_VALUE;
        }

        function stateTag() {
            const currChar = chars.getCurr();
            const nextChar = chars.getNext();
            chars.skip();
            const substr = chars.substrUntilChar(closeTag);
            const hasInvalidChars = substr.length === 0 || substr.indexOf(openTag) >= 0;
            if (nextChar && isCharReserved(nextChar) || hasInvalidChars || chars.isLast()) {
                emitToken(TYPE_WORD, currChar);
                return STATE_WORD;
            }
            const isNoAttrsInTag = substr.indexOf(EQ) === -1;
            const isClosingTag = substr[0] === SLASH;
            if (isNoAttrsInTag || isClosingTag) {
                const startPos = chars.getPos() - 1;
                const name = chars.grabWhile((char) => char !== closeTag);
                const endPos = startPos + name.length + END_POS_OFFSET;
                chars.skip();
                emitToken(TYPE_TAG, name, startPos, endPos);
                checkContextFreeMode(name, isClosingTag);
                return STATE_WORD;
            }
            return STATE_TAG_ATTRS;
        }

        function stateAttrs() {
            const startPos = chars.getPos();
            const silent = true;
            const tagStr = chars.grabWhile((char) => char !== closeTag, silent);
            const tagGrabber = createCharGrabber(tagStr, {
                onSkip
            });
            const hasSpace = tagGrabber.includes(SPACE);
            tagMode = TAG_STATE_NAME;
            while (tagGrabber.hasNext()) {
                tagMode = nextTagState(tagGrabber, !hasSpace, startPos);
            }
            chars.skip();
            return STATE_WORD;
        }

        function stateWord() {
            if (isNewLine(chars.getCurr())) {
                emitToken(TYPE_NEW_LINE, chars.getCurr());
                chars.skip();
                col = 0;
                prevCol = 0;
                row++;
                return STATE_WORD;
            }
            if (isWhiteSpace(chars.getCurr())) {
                const word2 = chars.grabWhile(isWhiteSpace);
                emitToken(TYPE_SPACE, word2);
                return STATE_WORD;
            }
            if (chars.getCurr() === openTag) {
                if (contextFreeTag) {
                    const fullTagLen = openTag.length + SLASH.length + contextFreeTag.length;
                    const fullTagName = `${openTag}${SLASH}${contextFreeTag}`;
                    const foundTag = chars.grabN(fullTagLen);
                    const isEndContextFreeMode = foundTag === fullTagName;
                    if (isEndContextFreeMode) {
                        return STATE_TAG;
                    }
                } else if (chars.includes(closeTag)) {
                    return STATE_TAG;
                }
                emitToken(TYPE_WORD, chars.getCurr());
                chars.skip();
                prevCol++;
                return STATE_WORD;
            }
            if (escapeTags) {
                if (isEscapeChar(chars.getCurr())) {
                    const currChar = chars.getCurr();
                    const nextChar = chars.getNext();
                    chars.skip();
                    if (nextChar && isEscapableChar(nextChar)) {
                        chars.skip();
                        emitToken(TYPE_WORD, nextChar);
                        return STATE_WORD;
                    }
                    emitToken(TYPE_WORD, currChar);
                    return STATE_WORD;
                }
                const isChar = (char) => isCharToken(char) && !isEscapeChar(char);
                const word2 = chars.grabWhile(isChar);
                emitToken(TYPE_WORD, word2);
                return STATE_WORD;
            }
            const word = chars.grabWhile(isCharToken);
            emitToken(TYPE_WORD, word);
            return STATE_WORD;
        }

        function tokenize() {
            stateMode = STATE_WORD;
            while (chars.hasNext()) {
                switch (stateMode) {
                    case STATE_TAG:
                        stateMode = stateTag();
                        break;
                    case STATE_TAG_ATTRS:
                        stateMode = stateAttrs();
                        break;
                    case STATE_WORD:
                    default:
                        stateMode = stateWord();
                        break;
                }
            }
            tokens.length = tokenIndex + 1;
            return tokens;
        }

        function isTokenNested(token) {
            const value = openTag + SLASH + token.getValue();
            if (nestedMap.has(value)) {
                return !!nestedMap.get(value);
            } else {
                const status = buffer.indexOf(value) > -1;
                nestedMap.set(value, status);
                return status;
            }
        }

        return {
            tokenize,
            isTokenNested
        };
    }

    // node_modules/@bbob/parser/es/parse.js
    var NodeList = class {
        last() {
            if (Array.isArray(this.n) && this.n.length > 0 && typeof this.n[this.n.length - 1] !== "undefined") {
                return this.n[this.n.length - 1];
            }
            return null;
        }

        flush() {
            return this.n.length ? this.n.pop() : false;
        }

        push(value) {
            this.n.push(value);
        }

        toArray() {
            return this.n;
        }

        constructor() {
            this.n = [];
        }
    };
    var createList = () => new NodeList();

    function parse(input, opts = {}) {
        const options = opts;
        const openTag = options.openTag || OPEN_BRAKET;
        const closeTag = options.closeTag || CLOSE_BRAKET;
        const onlyAllowTags = (options.onlyAllowTags || []).filter(Boolean).map((tag) => tag.toLowerCase());
        let tokenizer = null;
        const nodes = createList();
        const nestedNodes = createList();
        const tagNodes = createList();
        const tagNodesAttrName = createList();
        const nestedTagsMap = /* @__PURE__ */ new Set();

        function isTokenNested(token) {
            const value = token.getValue();
            const {isTokenNested: isTokenNested2} = tokenizer || {};
            if (!nestedTagsMap.has(value) && isTokenNested2 && isTokenNested2(token)) {
                nestedTagsMap.add(value);
                return true;
            }
            return nestedTagsMap.has(value);
        }

        function isTagNested(tagName) {
            return Boolean(nestedTagsMap.has(tagName));
        }

        function isAllowedTag(value) {
            if (onlyAllowTags.length) {
                return onlyAllowTags.indexOf(value.toLowerCase()) >= 0;
            }
            return true;
        }

        function flushTagNodes() {
            if (tagNodes.flush()) {
                tagNodesAttrName.flush();
            }
        }

        function getNodes() {
            const lastNestedNode2 = nestedNodes.last();
            if (lastNestedNode2 && isTagNode(lastNestedNode2)) {
                return lastNestedNode2.content;
            }
            return nodes.toArray();
        }

        function appendNodeAsString(nodes2, node, isNested = true) {
            if (Array.isArray(nodes2) && typeof node !== "undefined") {
                nodes2.push(node.toTagStart({
                    openTag,
                    closeTag
                }));
                if (Array.isArray(node.content) && node.content.length) {
                    node.content.forEach((item) => {
                        nodes2.push(item);
                    });
                    if (isNested) {
                        nodes2.push(node.toTagEnd({
                            openTag,
                            closeTag
                        }));
                    }
                }
            }
        }

        function appendNodes(nodes2, node) {
            if (Array.isArray(nodes2) && typeof node !== "undefined") {
                if (isTagNode(node)) {
                    if (isAllowedTag(node.tag)) {
                        nodes2.push(node.toTagNode());
                    } else {
                        appendNodeAsString(nodes2, node);
                    }
                } else {
                    nodes2.push(node);
                }
            }
        }

        function handleTagStart(token) {
            flushTagNodes();
            const tagNode = TagNode.create(token.getValue(), {}, [], {
                from: token.getStart(),
                to: token.getEnd()
            });
            const isNested = isTokenNested(token);
            tagNodes.push(tagNode);
            if (isNested) {
                nestedNodes.push(tagNode);
            } else {
                const nodes2 = getNodes();
                appendNodes(nodes2, tagNode);
            }
        }

        function handleTagEnd(token) {
            const lastTagNode = nestedNodes.last();
            if (isTagNode(lastTagNode)) {
                lastTagNode.setEnd({
                    from: token.getStart(),
                    to: token.getEnd()
                });
            }
            flushTagNodes();
            const lastNestedNode2 = nestedNodes.flush();
            if (lastNestedNode2) {
                const nodes2 = getNodes();
                appendNodes(nodes2, lastNestedNode2);
            } else if (typeof options.onError === "function") {
                const tag = token.getValue();
                const line = token.getLine();
                const column = token.getColumn();
                options.onError({
                    tagName: tag,
                    lineNumber: line,
                    columnNumber: column
                });
            }
        }

        function handleTag(token) {
            if (token.isStart()) {
                handleTagStart(token);
            }
            if (token.isEnd()) {
                handleTagEnd(token);
            }
        }

        function handleNode(token) {
            const activeTagNode = tagNodes.last();
            const tokenValue = token.getValue();
            const isNested = isTagNested(token.toString());
            const nodes2 = getNodes();
            if (activeTagNode !== null) {
                if (token.isAttrName()) {
                    tagNodesAttrName.push(tokenValue);
                    const attrName = tagNodesAttrName.last();
                    if (attrName) {
                        activeTagNode.attr(attrName, "");
                    }
                } else if (token.isAttrValue()) {
                    const attrName = tagNodesAttrName.last();
                    if (attrName) {
                        activeTagNode.attr(attrName, tokenValue);
                        tagNodesAttrName.flush();
                    } else {
                        activeTagNode.attr(tokenValue, tokenValue);
                    }
                } else if (token.isText()) {
                    if (isNested) {
                        activeTagNode.append(tokenValue);
                    } else {
                        appendNodes(nodes2, tokenValue);
                    }
                } else if (token.isTag()) {
                    appendNodes(nodes2, token.toString());
                }
            } else if (token.isText()) {
                appendNodes(nodes2, tokenValue);
            } else if (token.isTag()) {
                appendNodes(nodes2, token.toString());
            }
        }

        function onToken(token) {
            if (token.isTag()) {
                handleTag(token);
            } else {
                handleNode(token);
            }
        }

        const lexer = opts.createTokenizer ? opts.createTokenizer : createLexer;
        tokenizer = lexer(input, {
            onToken,
            openTag,
            closeTag,
            onlyAllowTags: options.onlyAllowTags,
            contextFreeTags: options.contextFreeTags,
            enableEscapeTags: options.enableEscapeTags
        });
        const tokens = tokenizer.tokenize();
        const lastNestedNode = nestedNodes.flush();
        if (lastNestedNode !== null && lastNestedNode && isTagNode(lastNestedNode) && isTagNested(lastNestedNode.tag)) {
            appendNodeAsString(getNodes(), lastNestedNode, false);
        }
        return nodes.toArray();
    }

    // node_modules/@bbob/core/es/utils.js
    var isObj = (value) => typeof value === "object" && value !== null;
    var isBool = (value) => typeof value === "boolean";

    function iterate(t, cb) {
        const tree = t;
        if (Array.isArray(tree)) {
            for (let idx = 0; idx < tree.length; idx++) {
                tree[idx] = iterate(cb(tree[idx]), cb);
            }
        } else if (isObj(tree) && "content" in tree) {
            iterate(tree.content, cb);
        }
        return tree;
    }

    function same(expected, actual) {
        if (typeof expected !== typeof actual) {
            return false;
        }
        if (!isObj(expected) || expected === null) {
            return expected === actual;
        }
        if (Array.isArray(expected)) {
            return expected.every((exp) => [].some.call(actual, (act) => same(exp, act)));
        }
        if (isObj(expected) && isObj(actual)) {
            return Object.keys(expected).every((key) => {
                const ao = actual[key];
                const eo = expected[key];
                if (isObj(eo) && isObj(ao)) {
                    return same(eo, ao);
                }
                if (isBool(eo)) {
                    return eo !== (ao === null);
                }
                return ao === eo;
            });
        }
        return false;
    }

    function match(t, expression, cb) {
        if (Array.isArray(expression)) {
            return iterate(t, (node) => {
                for (let idx = 0; idx < expression.length; idx++) {
                    if (same(expression[idx], node)) {
                        return cb(node);
                    }
                }
                return node;
            });
        }
        return iterate(t, (node) => same(expression, node) ? cb(node) : node);
    }

    // node_modules/@bbob/core/es/errors.js
    var C1 = "C1";
    var C2 = "C2";
    if (true) {
        C1 = '"parser" is not a function, please pass to "process(input, { parser })" right function';
        C2 = '"render" function not defined, please pass to "process(input, { render })"';
    }

    // node_modules/@bbob/core/es/index.js
    function createTree(tree, options) {
        const extendedTree = tree;
        extendedTree.messages = [
            ...extendedTree.messages || []
        ];
        extendedTree.options = {
            ...options,
            ...extendedTree.options
        };
        extendedTree.walk = function walkNodes(cb) {
            return iterate(this, cb);
        };
        extendedTree.match = function matchNodes(expr, cb) {
            return match(this, expr, cb);
        };
        return extendedTree;
    }

    function bbob(plugs) {
        const plugins = typeof plugs === "function" ? [
            plugs
        ] : plugs || [];
        const mockRender = () => "";
        return {
            process(input, opts) {
                const options = opts || {
                    skipParse: false,
                    parser: parse,
                    render: mockRender,
                    data: null
                };
                const parseFn = options.parser || parse;
                const renderFn = options.render;
                const data = options.data || null;
                if (typeof parseFn !== "function") {
                    throw new Error(C1);
                }
                const raw = options.skipParse && Array.isArray(input) ? input : parseFn(input, options);
                let tree = options.skipParse && Array.isArray(input) ? createTree(input || [], options) : createTree(raw, options);
                for (let idx = 0; idx < plugins.length; idx++) {
                    const plugin = plugins[idx];
                    if (typeof plugin === "function" && renderFn) {
                        const newTree = plugin(tree, {
                            parse: parseFn,
                            render: renderFn,
                            iterate,
                            data
                        });
                        tree = createTree(newTree || tree, options);
                    }
                }
                return {
                    get html() {
                        if (typeof renderFn !== "function") {
                            throw new Error(C2);
                        }
                        return renderFn(tree, tree.options);
                    },
                    tree,
                    raw,
                    messages: tree.messages
                };
            }
        };
    }

    // node_modules/@bbob/html/es/index.js
    var SELFCLOSE_END_TAG = "/>";
    var CLOSE_START_TAG = "</";
    var START_TAG = "<";
    var END_TAG = ">";

    function renderNode(node, options) {
        const {stripTags = false} = options || {};
        if (typeof node === "undefined" || node === null) {
            return "";
        }
        if (typeof node === "string" || typeof node === "number") {
            return String(node);
        }
        if (Array.isArray(node)) {
            return render(node, options);
        }
        if (isTagNode(node)) {
            if (stripTags) {
                return render(node.content, options);
            }
            const attrs = attrsToString(node.attrs);
            if (node.content === null) {
                return START_TAG + node.tag + attrs + SELFCLOSE_END_TAG;
            }
            return START_TAG + node.tag + attrs + END_TAG + render(node.content, options) + CLOSE_START_TAG + node.tag + END_TAG;
        }
        return "";
    }

    function render(nodes, options) {
        if (nodes && Array.isArray(nodes)) {
            return nodes.reduce((r, node) => r + renderNode(node, options), "");
        }
        if (nodes) {
            return renderNode(nodes, options);
        }
        return "";
    }

    function html(source, plugins, options) {
        return bbob(plugins).process(source, {
            ...options,
            render
        }).html;
    }

    var es_default = html;

    // node_modules/@bbob/preset/es/preset.js
    function process2(tags, tree, core, options) {
        return tree.walk((node) => {
            if (isTagNode(node)) {
                const tag = node.tag;
                const tagCallback = tags[tag];
                if (typeof tagCallback === "function") {
                    return tagCallback(node, core, options);
                }
            }
            return node;
        });
    }

    function createPreset(defTags, processor = process2) {
        const presetFactory = (opts) => {
            presetFactory.options = Object.assign(presetFactory.options || {}, opts);

            function presetExecutor(tree, core) {
                return processor(defTags, tree, core, presetFactory.options || {});
            }

            presetExecutor.options = presetFactory.options;
            return presetExecutor;
        };
        presetFactory.extend = function presetExtend(callback) {
            const newTags = callback(defTags, presetFactory.options);
            return createPreset(newTags, processor);
        };
        return presetFactory;
    }

    // node_modules/@bbob/preset-html5/es/defaultTags.js
    var isStartsWith = (node, type) => node[0] === type;
    var styleAttrs = (attrs) => {
        const values = attrs || {};
        return Object.keys(values).reduce((acc, key) => {
            const value = values[key];
            if (typeof value === "string") {
                if (key === "color") {
                    return acc.concat(`color:${value};`);
                }
                if (key === "size") {
                    return acc.concat(`font-size:${value};`);
                }
            }
            return acc;
        }, []).join(" ");
    };
    var toListNodes = (content) => {
        if (content && Array.isArray(content)) {
            return content.reduce((acc, node) => {
                const listItem = acc[acc.length - 1];
                if (isStringNode(node) && isStartsWith(String(node), "*")) {
                    const content2 = String(node).slice(1);
                    acc.push(TagNode.create("li", {}, [
                        content2
                    ]));
                    return acc;
                }
                if (isTagNode(node) && TagNode.isOf(node, "*")) {
                    acc.push(TagNode.create("li", {}, []));
                    return acc;
                }
                if (!isTagNode(listItem)) {
                    acc.push(node);
                    return acc;
                }
                if (listItem && isTagNode(listItem) && Array.isArray(listItem.content)) {
                    listItem.content = listItem.content.concat(node);
                    return acc;
                }
                acc.push(node);
                return acc;
            }, []);
        }
        return content;
    };
    var renderUrl = (node, render2) => getUniqAttr(node.attrs) ? getUniqAttr(node.attrs) : render2(node.content || []);
    var toNode = (tag, attrs, content) => TagNode.create(tag, attrs, content);
    var toStyle = (style) => ({
        style
    });
    var defineStyleNode = (tag, style) => (node) => toNode(tag, toStyle(style), node.content);
    var defaultTags = function createTags() {
        const tags = {
            b: defineStyleNode("span", "font-weight: bold;"),
            i: defineStyleNode("span", "font-style: italic;"),
            u: defineStyleNode("span", "text-decoration: underline;"),
            s: defineStyleNode("span", "text-decoration: line-through;"),
            url: (node, {render: render2}) => toNode("a", {
                href: renderUrl(node, render2)
            }, node.content),
            img: (node, {render: render2}) => toNode("img", {
                src: render2(node.content)
            }, null),
            quote: (node) => toNode("blockquote", {}, [
                toNode("p", {}, node.content)
            ]),
            code: (node) => toNode("pre", {}, node.content),
            style: (node) => toNode("span", toStyle(styleAttrs(node.attrs)), node.content),
            list: (node) => {
                const type = getUniqAttr(node.attrs);
                return toNode(type ? "ol" : "ul", type ? {
                    type
                } : {}, toListNodes(node.content));
            },
            color: (node) => toNode("span", toStyle(`color: ${getUniqAttr(node.attrs)};`), node.content)
        };
        return tags;
    }();
    var defaultTags_default = defaultTags;

    // node_modules/@bbob/preset-html5/es/index.js
    var es_default2 = createPreset(defaultTags_default);

    // app.js
    function convertBBCode(input) {
        return es_default(input, es_default2());
    }

    globalThis.convertBBCode = convertBBCode;
})();
