package handwrittenparser;

import expression.*;

public class Parser {
    private TokenInputStream tokenizer;

    public Parser(String string) {
        tokenizer = new TokenInputStream(string);
    }

    public Expression parse() {
        return parseImplication();
    }

    private Expression parseImplication() {
        Expression implication = parseDisjunction();
        //System.out.println("Impl " + implication.toString() + " " + tokenizer.getCurrentIndex());
        while (tokenizer.hasMoreTokens()) {
            Token token = tokenizer.getCurrentToken();
            tokenizer.moveFront();
            if (token.getTokenType() == Tokens.IMPLICATION) {
                implication = new Implication(implication, parseImplication());
            } else {
                tokenizer.moveBack();
                return implication;
            }
        }
        return implication;
    }

    private Expression parseDisjunction() {
        Expression disjunction = parseConjunction();
        //System.out.println("Disj " + disjunction.toString() + " " + tokenizer.getCurrentIndex());
        while (tokenizer.hasMoreTokens()) {
            Token token = tokenizer.getCurrentToken();
            tokenizer.moveFront();
            if (token.getTokenType() == Tokens.DISJUNCTION) {
                disjunction = new Disjunction(disjunction, parseConjunction());
            } else {
                tokenizer.moveBack();
                return disjunction;
            }
        }
        return disjunction;
    }

    private Expression parseConjunction() {
        Expression conjunction = parseAtomic();
        //System.out.println("Conj " + conjunction.toString() + " " + tokenizer.getCurrentIndex());
        while (tokenizer.hasMoreTokens()) {
            Token token = tokenizer.getCurrentToken();
            tokenizer.moveFront();
            if (token.getTokenType() == Tokens.CONJUNCTION) {
                conjunction = new Conjunction(conjunction, parseAtomic());
            } else {
                tokenizer.moveBack();
                return conjunction;
            }
        }
        return conjunction;
    }

    private Expression parseAtomic() {
        Expression atomic = null;
        assert (tokenizer.hasMoreTokens());
        Token token = tokenizer.getCurrentToken();
        tokenizer.moveFront();
        Tokens tokenType = token.getTokenType();
        switch (tokenType) {
            case NEGATION:
                atomic = new Negation(parseAtomic());
                break;

            case VARIABLE:
                PropositionalVariable variable = (PropositionalVariable)token;
                atomic = new Variable(variable.getName());
                break;

            case LEFT_PARENTHESIS:
                atomic = parseImplication();
                assert (tokenizer.getCurrentToken().getTokenType() == Tokens.RIGHT_PARENTHESIS);
                tokenizer.moveFront();
                break;
        }
        return atomic;
    }
}
