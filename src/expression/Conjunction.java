package expression;

import java.util.Objects;

public class Conjunction extends BinaryOperation {

    public Conjunction(Expression left, Expression right) {
        super(left, right);
    }

    @Override
    public String getSymbol() {
        return "&";
    }
}
