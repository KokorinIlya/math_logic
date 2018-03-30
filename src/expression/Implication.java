package expression;

import java.util.Objects;

public class Implication extends BinaryOperation {

    public Implication(Expression left, Expression right) {
        super(left, right);
    }

    @Override
    public String getSymbol() {
        return "->";
    }
}
