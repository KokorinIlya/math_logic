package handwrittenparser;

import axioms.ClassicAxioms;
import axioms.PatternMatcher;
import expression.Expression;

import java.util.List;

public class ParserTest {
    public static void main(String[] args) {
        Parser parser = new Parser("A->(B&!A)->!A98");
        Expression expression = parser.parse();
        System.out.println(expression.toTree());
        System.out.println(ClassicAxioms.axioms[1].toTree());
        System.out.println(new PatternMatcher(ClassicAxioms.axioms[1]).check(expression));
    }
}
