package handwrittenparser;

class Token {
    private Tokens tokenType;

    public Tokens getTokenType() {
        return tokenType;
    }


    public Token(Tokens tokenType) {
        this.tokenType = tokenType;
    }
}
