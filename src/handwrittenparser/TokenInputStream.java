package handwrittenparser;

import java.util.List;

class TokenInputStream {
    private List<Token> tokens;
    private int currentIndex = 0;

    TokenInputStream(String string) {
        tokens = new Lexer(string).tokenize();
    }

    public int getCurrentIndex() {
        return currentIndex;
    }

    void moveFront() {
        currentIndex++;
    }

    void moveBack() {
        currentIndex--;
    }

    Token getCurrentToken() {
        return tokens.get(currentIndex);
    }

    boolean hasMoreTokens() {
        return currentIndex < tokens.size();
    }
}
