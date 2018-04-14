package utils;

import expression.Expression;
import handwrittenparser.Parser;

public class ExpressionMaker {
    public static Expression makeExpression(String s) {
        return new Parser(s).parse();
    }

    public static String prepareForProcessing(String s) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            if (!Character.isWhitespace(s.charAt(i))) {
                builder.append(s.charAt(i));
            }
        }
        return builder.toString();
    }
}
