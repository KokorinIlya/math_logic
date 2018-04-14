package axioms;

import expression.Expression;
import utils.ExpressionMaker;

public class ClassicAxioms {
    private static String[] textAxioms = new String[] {
            "",
            "A->B->A", //1
            "(A->B)->(A->B->C)->(A->C)", //2
            "A->B->A&B", //3
            "(A&B)->A", //4
            "(A&B)->B", //5
            "A->(A|B)", //6
            "B->(A|B)", //7
            "(A->C)->(B->C)->((A|B)->C)", //8
            "(A->B)->(A->(!B))->(!A)", //9
            "(!!A)->A" //10
    };

    public static Expression[] axioms = new Expression[11];

    private static void initializeAxiom(int i) {
        axioms[i] = ExpressionMaker.makeExpression(textAxioms[i]);
    }

    static {
        for (int i = 1; i <= 10; i++) {
            initializeAxiom(i);
        }
    }
}
