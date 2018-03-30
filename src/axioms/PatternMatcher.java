package axioms;

import expression.Expression;
import expression.Variable;

import java.util.HashMap;

public class PatternMatcher {
    private HashMap<Variable, Expression> substitution;
    private Expression pattern;

    public PatternMatcher(Expression pattern) {
        this.pattern = pattern;
        substitution = new HashMap<>();
    }

    private boolean walkAndCheck(Expression fromAxiom, Expression toCheck) {
        if (fromAxiom instanceof Variable) {
            Variable axiomVariable = (Variable)fromAxiom;
            if (!substitution.containsKey(axiomVariable)) {
                substitution.put(axiomVariable, toCheck);
                return true;
            } else {
                return substitution.get(axiomVariable).equals(toCheck);
            }
        }
        if (!fromAxiom.getSymbol().equals(toCheck.getSymbol())) {
            return false;
        }
        Expression[] axiomChildren = fromAxiom.getChildren();
        Expression[] toCheckChildren = toCheck.getChildren();
        for (int i = 0; i < axiomChildren.length; i++) {
            if (!walkAndCheck(axiomChildren[i], toCheckChildren[i])) {
                return false;
            }
        }
        return true;
    }

    public boolean check(Expression other) {
        substitution.clear();
        return walkAndCheck(pattern, other);
    }
}
