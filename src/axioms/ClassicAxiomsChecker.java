package axioms;

import expression.Expression;

public class ClassicAxiomsChecker {
    private static PatternMatcher[] axiomCheckers = new PatternMatcher[11];

    static {
        for (int i = 1; i <= 10; i++) {
            axiomCheckers[i] = new PatternMatcher(ClassicAxioms.axioms[i]);
        }
    }

    public static boolean checkOne(Expression expression, int i) {
        assert (1 <= i && i <= 10);
        return axiomCheckers[i].check(expression);
    }

    public static int checkAll(Expression expression) {
        for (int i = 1; i <= 10; i++) {
            if (checkOne(expression, i)) {
                return i;
            }
        }
        return 0;
    }
}
