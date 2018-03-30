package utils;

import expression.Expression;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import parser.ExpressionLexer;
import parser.ExpressionParser;

public class ExpressionMaker {
    public static Expression makeExpression(String s) {
        return new ExpressionParser(
                new CommonTokenStream(
                        new ExpressionLexer(
                                new ANTLRInputStream(
                                        s
                                )
                        )
                )
        ).expression().expr;
    }
}
