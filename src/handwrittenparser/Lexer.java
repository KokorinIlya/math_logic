package handwrittenparser;

import java.util.ArrayList;
import java.util.List;

class Lexer {
    private int currentStringIndex = 0;
    private String string;

    Lexer(String string) {
        this.string = string;
    }

    Lexer reset() {
        currentStringIndex = 0;
        return this;
    }

    List<Token> tokenize() {
        List<Token> tokens = new ArrayList<>();
        while (currentStringIndex < string.length()) {
            while (Character.isWhitespace(string.charAt(currentStringIndex))) {
                currentStringIndex++;
            }

            char currentChar = string.charAt(currentStringIndex);
            switch (currentChar) {
                case '&':
                    tokens.add(new Token(Tokens.CONJUNCTION));
                    break;

                case '|':
                    tokens.add(new Token(Tokens.DISJUNCTION));
                    break;

                case '-':
                    //TODO exception
                    assert (currentStringIndex != string.length() - 1 &&
                            string.charAt(currentStringIndex + 1) == '>');
                    tokens.add(new Token(Tokens.IMPLICATION));
                    currentStringIndex++;
                    break;

                case '!':
                    tokens.add(new Token(Tokens.NEGATION));
                    break;

                case '(':
                    tokens.add(new Token(Tokens.LEFT_PARENTHESIS));
                    break;

                case ')':
                    tokens.add(new Token(Tokens.RIGHT_PARENTHESIS));
                    break;

                default:
                    assert (Character.isLetterOrDigit(string.charAt(currentStringIndex)));

                    int startPosition = currentStringIndex;
                    while (currentStringIndex < string.length() &&
                            Character.isLetterOrDigit(string.charAt(currentStringIndex))) {
                        currentStringIndex++;
                    }
                    tokens.add(new PropositionalVariable(string.substring(startPosition, currentStringIndex)));
                    currentStringIndex--;
            }
            currentStringIndex++;
        }
        return tokens;
    }

}
